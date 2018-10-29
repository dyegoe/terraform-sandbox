resource "aws_cloudwatch_log_group" "docker_app_logs" {
  name = "${var.project_name}-docker-app-logs"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-docker-app-logs"
    )
  )}"
}