resource "aws_lb" "main" {
  name = "${var.project_name}-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.lb.id}"]
  subnets = ["${aws_subnet.public.*.id}"]
  access_logs {
    bucket = "${aws_s3_bucket.lb-logs.id}"
    prefix = "${var.project_name}-lb"
    enabled = true
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-lb"
    )
  )}"
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = "${aws_lb.main.arn}"
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.main.arn}"
  }
}

resource "aws_lb_target_group" "main" {
  name = "${var.project_name}-lb-tg-main"
  port = 5000
  protocol = "HTTP"
  vpc_id = "${aws_vpc.main.id}"
  health_check {
    path = "/health/"
  }
  stickiness {
    type = "lb_cookie"
    enabled = true
  }
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-lb-tg-main"
    )
  )}"
}

resource "aws_lb_target_group_attachment" "main" {
  count = "${var.instance_app_count}"
  target_group_arn = "${aws_lb_target_group.main.arn}"
  target_id        = "${element(aws_instance.app.*.id, count.index)}"
  port             = 5000
}

output "aws_lb_main_dns_name" {
  value = "${aws_lb.main.dns_name}"
}

output "aws_lb_listener_main_id" {
  value = "${aws_lb_listener.main.id}"
}
