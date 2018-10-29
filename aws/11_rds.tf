resource "aws_db_subnet_group" "main" {
  name = "${var.project_name}-rds-sg-main"
  subnet_ids = ["${aws_subnet.public.*.id}"]
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-rds-sg-main"
    )
  )}"
}

resource "aws_db_instance" "main" {
  count = "${var.db_instance_count}"
  allocated_storage = 10
  apply_immediately = false
  availability_zone = "${var.aws_region}a"
  backup_retention_period = 5
  backup_window = "05:00-07:00"
  copy_tags_to_snapshot = true
  db_subnet_group_name = "${aws_db_subnet_group.main.id}"
  engine = "postgres"
  engine_version = "10.4"
  identifier = "${var.project_name}-rds-${count.index}"
  instance_class = "${var.db_instance}"
  maintenance_window = "Mon:00:00-Mon:03:00"
  name = "${var.db_name}"
  parameter_group_name = "default.postgres10"
  password = "${var.db_password}"
  publicly_accessible = false
  skip_final_snapshot = true
  storage_type = "gp2"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-rds-${count.index}"
    )
  )}"
  username = "${var.db_user}"
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  timeouts {
    create = "30m"
    delete = "1h"
  }
}

output "aws_db_instance_main_endpoint" {
  value = "${aws_db_instance.main.*.endpoint}"
}

output "aws_db_instance_db_name" {
  value = "${var.db_name}"
}

output "aws_db_instance_db_user" {
  value = "${var.db_user}"
}

output "aws_db_instance_db_password" {
  value = "${var.db_password}"
}
