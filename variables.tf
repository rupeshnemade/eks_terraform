variable "region" {
  type        = "string"
  description = "The region the EKS cluster will be located."
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name you would like associated with your eks cluster "
}

variable "cluster_version" {
  description = "EKS k8s supported version"
  default     = "1.14"
}

variable "remote_state_bucket" {}

variable "stage" {
  description = "The API Gateway deployemnt stage"
}

variable "home_directory" {
  type = "string"
  description = "The user home directory"
}

variable "key_name" {
  description = "The key pair to attach the instances."
}

