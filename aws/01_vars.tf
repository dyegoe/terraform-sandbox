variable "aws_access_key_id" {}

variable "aws_secret_access_key" {}

variable "aws_region" {}

variable "public_key" {}

variable "project_name" {}

variable "vpc_cidr" {}

variable "vpc_subnets_count" {
  default = 2
}


variable "amis" {
  type = "map"
  default = {
    "ap-south-1" = "ami-0912f71e06545ad88"
    "eu-west-3" = "ami-0ebc281c20e89ba4b"
    "eu-west-2" = "ami-f976839e"
    "eu-west-1" = "ami-047bb4163c506cd98"
    "ap-northeast-2" = "ami-0a10b2721688ce9d2"
    "ap-northeast-1" = "ami-06cd52961ce9f0d85"
    "sa-east-1" = "ami-07b14488da8ea02a0"
    "ca-central-1" = "ami-0b18956f"
    "ap-southeast-1" = "ami-08569b978cc4dfa10"
    "ap-southeast-2" = "ami-09b42976632b27e9b"
    "eu-central-1" = "ami-0233214e13e500f77"
    "us-east-1" = "ami-0ff8a91507f77f867"
    "us-east-2" = "ami-0b59bfac6be064b78"
    "us-west-1" = "ami-0bdb828fd58c52235"
    "us-west-2" = "ami-a0cfeed8"
  }
}

variable "instance_type" {
  default = "t3.micro"
}

variable "instance_app_count" {}

variable "db_name" {}

variable "db_user" {}

variable "db_password" {}

variable "db_instance" {}

variable "db_instance_count" {
  default = 1
}


locals {
  common_tags = {
    Project = "${var.project_name}"
    Environment = "develop"
  }
}