resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-vpc"
    )
  )}"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-igw"
    )
  )}"
}

resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-rtb"
    )
  )}"
}

resource "aws_route" "default" {
  route_table_id = "${aws_route_table.main.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
}

variable "zones" {
    default = {
        "0" = "a"
        "1" = "b"
        "2" = "c"
        "3" = "d"
        "4" = "e"
        "5" = "f"
    }
}

resource "aws_subnet" "public" {
  count = "${var.vpc_subnets_count}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)}"
  availability_zone = "${var.aws_region}${lookup(var.zones, count.index)}"
  map_public_ip_on_launch = true
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-sn-pub-${lookup(var.zones, count.index)}"
    )
  )}"
}

resource "aws_route_table_association" "public" {
  count = "${var.vpc_subnets_count}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.main.id}"
}
