/*
# Create an Elastigroup
resource "spotinst_ocean_aws" "ocean_cluster" {
  name          = "${var.ocean_cluster_name}"
  controller_id = "${var.controller_id}"
  region        = "${var.region}"

  max_size         = "${var.max_size}"
  min_size         = "${var.min_size}"
  desired_capacity = "${var.desired_capacity}"
  whitelist        = "${var.permitted_ec2_types}"

  # ["t2.large", "m5.large"]

  # subnet_ids = ["${module.vpc.private_subnets}"]
  subnet_ids                  = "${var.subnets}"
  image_id                    = "${var.ami}"
  security_groups             = ["${aws_security_group.all_worker_mgmt.id}", "${module.eks.worker_security_group_id}"]
  key_name                    = "${var.key_name}"
  associate_public_ip_address = true
  user_data = <<-EOF
      #!/bin/bash
      set -o xtrace
      /etc/eks/bootstrap.sh ${var.cluster_name}
      EOF
  iam_instance_profile = "${aws_iam_instance_profile.workers.arn}"
  tags = [
    {
      key   = "Name"
      value = "${var.cluster_name}-ocean_cluster-Node"
    },
    {
      key   = "kubernetes.io/cluster/${var.cluster_name}"
      value = "owned"
    },
  ]
  autoscaler = {
    autoscale_is_enabled     = true
    autoscale_is_auto_config = false
    autoscale_cooldown       = 300

    autoscale_down = {
      evaluation_periods = 300
    }

    resource_limits = {
      max_vcpu       = 1000
      max_memory_gib = 2000
    }
  }
  depends_on = ["module.eks"]
}
*/