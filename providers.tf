terraform {
  required_version = ">= 0.11.14"
}

provider "aws" {
  version = ">= 2.11"
  region  = "${var.region}"
}

provider "random" {
  version = "~> 2.1"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}
