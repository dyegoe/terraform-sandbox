resource "aws_ecr_repository" "main" {
  name = "${var.project_name}"
}

output "aws_ecr_repository_main_repository_url" {
  value = "${aws_ecr_repository.main.repository_url}"
}
