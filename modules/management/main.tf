// Create A VPC with multi AZ private and public subnets
module "vpc" {
  // Use the comminity VPC module with a pinned revision number
  source          = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=f7a874cb2c74815d301608c3fe6eadf02cc57be5"
  name            = "${var.project_name}-${var.module_instance_id}"
  cidr            = "${var.vpc_cidr}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

  // enable nat gateway
  enable_nat_gateway = "true"

  // This sets the search domain in DHCP options
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    "Name"         = "${var.environment}-${var.project_name}-${var.module_instance_id}"
    "terraform"    = "true"
    "environment"  = "${var.environment}"
    "project_name" = "${var.project_name}"
  }
}
