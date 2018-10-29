resource "aws_iam_user" "ecr_user" {
  name = "ecr_user"
  path = "/system/"
}

resource "aws_iam_access_key" "ecr_user" {
  user = "${aws_iam_user.ecr_user.id}"
}

resource "aws_iam_user_policy" "ecr_user" {
  name = "ecr_user_policy"
  user = "${aws_iam_user.ecr_user.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:BatchGetImage"
        ],
        "Resource": [ "*" ]
    }
  ]
}
EOF
}

output "aws_iam_access_key_ecr_user_id" {
  value = "${aws_iam_access_key.ecr_user.id}"
}

output "aws_iam_access_key_ecr_user_secret" {
  value = "${aws_iam_access_key.ecr_user.secret}"
}

resource "aws_iam_role_policy" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.ec2_profile.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "ec2_profile" {
  name = "ec2_profile"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
