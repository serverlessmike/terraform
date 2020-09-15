data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

data "aws_subnet_ids" "privates" {
  vpc_id = "${var.vpc_id}"

  filter {
    name   = "availabilityZone"
    values = ["${data.aws_availability_zones.available.names[0]}"]
  }

  filter {
    name   = "tag:private"
    values = ["true"]
  }
}

data "aws_ami" "wqf" {
  most_recent = true

  filter {
    name   = "name"
    values = ["aws-dms-wqf*"]
  }
}
