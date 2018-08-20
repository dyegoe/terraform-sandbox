provider "aws" {
  profile = "${var.profile}"
  region = "${var.region}"
}
resource "aws_instance" "example" {
  ami = "${lookup(var.amis, var.region)}"
  availability_zone = "${var.region}a"
  key_name = "dyego-default"
  instance_type = "t2.nano"
  security_groups = [ "open-ssh" ]
}
output "ip" {
  value = "${aws_instance.example.public_ip}"
}