# resource "random_string" "suffix" {
#   length  = 8
#   special = false
# }

# locals {
#   cluster_name = "ocean-eks"

#   tags = {}
# }

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket}"
    key    = "${var.region}/${var.stage}/network/terraform.tfstate"
    region = "${var.region}"
  }
}

locals {
  subnets            = ["${slice(data.terraform_remote_state.network.private-subnets,0,min(length(data.terraform_remote_state.network.azs),length(data.terraform_remote_state.network.private-subnets)))}"]
  vpc_id             = "${data.terraform_remote_state.network.vpc-id}"
}

module "eks" {
  version         = "v4.0.2"                        # requiered for terraform version < 0.12
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.cluster_name}"
  cluster_version = "${var.cluster_version}"
  subnets         = "${local.subnets}"
  vpc_id          = "${local.vpc_id}"

  worker_groups = [
    {
      name = "worker-1"
      instance_type = "t3.micro"
      asg_max_size  = 2
      //additional_security_group_ids = ["${aws_security_group.all_worker_mgmt.id}"]
      key_name      = "${var.key_name}"
      tags = [{
        key                 = "Name"
        value               = "k8s worker"
        propagate_at_launch = true
      }]
    }
  ]

  tags = {
    environment = "dev"
  }

  map_roles_count = 1

  map_roles = [
    {
      role_arn = "${aws_iam_role.workers.arn}"
      username = "system:node:{{EC2PrivateDNSName}}"
      group    = "system:nodes"
    },
  ]

  //worker_additional_security_group_ids = ["${aws_security_group.all_worker_mgmt.id}"]

  config_output_path = "${var.home_directory}/.kube/"          # to store file on jenkins machine in given path so that Jenkins can communicate cluster API for kubectl commands
}
