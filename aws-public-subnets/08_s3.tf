data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "lb-logs" {
  bucket = "${var.project_name}-s3-lb-logs"
  force_destroy = true
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.main.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.project_name}-s3-lb-logs/*"
    }
  ]
}
EOF
}
