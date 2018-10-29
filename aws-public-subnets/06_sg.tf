resource "aws_security_group" "ssh" {
  name = "${var.project_name}-ssh-sg"
  description = "Open SSH port"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-ssh-sg"
    )
  )}"
}

resource "aws_security_group" "lb" {
  name = "${var.project_name}-lb-sg"
  description = "Open HTTP port"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-lb-sg"
    )
  )}"
}

resource "aws_security_group" "lb-ec2" {
  name = "${var.project_name}-lb-ec2-sg"
  description = "Open access from LB to EC2 instances"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 5000
    to_port = 5999
    protocol = "TCP"
    security_groups = ["${aws_security_group.lb.id}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-lb-ec2-sg"
    )
  )}"
}

resource "aws_security_group" "rds" {
  name = "${var.project_name}-rds-sg"
  description = "Open database port from instances"
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "TCP"
    security_groups = ["${aws_security_group.ssh.id}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-rds-sg"
    )
  )}"
}