variable "aws_region" {
  type = "string"
  description = "Region to lookup for AMI"
}
output "amazonlinux" {
  value = "${lookup(local.amazonlinux, var.aws_region)}"
}
output "amazonlinuxecs" {
  value = "${lookup(local.amazonlinuxecs, var.aws_region)}"
}
output "ubuntu1404" {
  value = "${lookup(local.ubuntu1404, var.aws_region)}"
}
output "ubuntu1604" {
  value = "${lookup(local.ubuntu1604, var.aws_region)}"
}
output "ubuntu1804" {
  value = "${lookup(local.ubuntu1804, var.aws_region)}"
}