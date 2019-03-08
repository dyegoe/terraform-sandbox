# AMI Map

This is a module for terraform which has a local vars with AMIs map collected by python script.

AMIs provided by this modules:

- amazonlinux
- amazonlinuxecs
- ubuntu1404
- ubuntu1604
- ubuntu1804

## Usage

```terraform
locals {
  aws_region = "eu-central-1"
}

module "ami_ids" {
  source = "../modules/ami_ids"
  aws_region = "${local.aws_region}"
}

resource "aws_instance" "example" {
  ami = "${module.ami_ids.amazonlinux}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public-a.id}"
  key_name = "${aws_key_pair.default.key_name}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}", "${aws_security_group.app.id}"]
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-app"
    )
  )}"
}
```

## How to update the maps

```text
AWS_PROFILE=frankfurt <local repo path>/terraform-sandbox/modules/ami_ids/ami_ids.py
```