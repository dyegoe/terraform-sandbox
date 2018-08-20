provider "aws" {
  profile = "dyego"
  region     = "us-east-1"
}

module "consul" {
  source = "hashicorp/consul/aws"

  num_servers = "3"
}

output "consul_server_asg_name" {
  value = "${module.consul.asg_name_servers}"
}