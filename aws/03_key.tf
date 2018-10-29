resource "aws_key_pair" "default" {
  key_name = "${var.project_name}-key"
  public_key = "${file("${var.public_key}")}"
  lifecycle {
    ignore_changes = ["public_key"]
  }
}
