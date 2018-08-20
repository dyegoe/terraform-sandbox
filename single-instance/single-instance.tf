provider "aws" {
    profile = "ansible"
    region = "eu-west-1"
}

resource "aws_instance" "example" {
    ami = "ami-d834aba1"
    availability_zone = "eu-west-1a"
    key_name = "dyego-default"
    instance_type = "t2.nano"
    security_groups = [ "open-ssh" ]
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}