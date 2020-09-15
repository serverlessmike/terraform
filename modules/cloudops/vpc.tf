// Create A VPC with multi AZ private and public subnets

data "aws_availability_zones" "default" {}

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
  enable_s3_endpoint   = true

  enable_vpn_gateway                 = "${var.enable_vpn}"
  propagate_private_route_tables_vgw = "${var.propagate_private_route_tables_vgw}"

  tags {
    Name         = "${var.environment}-${var.project_name}-${var.module_instance_id}"
    repo         = "cloudops-terraform"
    environment  = "${var.environment}"
    terraform    = "true"
    tf_module    = "cloudops"
    project_name = "${var.project_name}"
  }

  public_subnet_tags {
    "type" = "public"
  }

  private_subnet_tags {
    "type" = "private"
  }
}

// dhcp options for Windows 
resource "aws_vpc_dhcp_options" "windoze_dhcp" {
  domain_name          = "hq.river-island.com"
  domain_name_servers  = ["10.150.130.16", "10.229.11.13"]
  ntp_servers          = ["127.0.0.1"]
  netbios_name_servers = ["127.0.0.1"]
  netbios_node_type    = 2

  tags {
    Name         = "windoze_dhcp"
    Name         = "${var.environment}-${var.project_name}-${var.module_instance_id}"
    repo         = "cloudops-terraform"
    environment  = "${var.environment}"
    terraform    = "true"
    tf_module    = "cloudops"
    project_name = "${var.project_name}"
  }
}

resource "aws_vpc_dhcp_options_association" "dhcp_association" {
  vpc_id          = "${module.vpc.vpc_id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.windoze_dhcp.id}"
}

resource "aws_subnet" "tgw" {
  count             = "${length(data.aws_availability_zones.default.names)}"
  availability_zone = "${data.aws_availability_zones.default.names[count.index]}"
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${element(var.vpc_tgw_subnets, count.index)}"

  tags {
    "Name" = "Network-${substr(data.aws_availability_zones.default.names[count.index],-1,-1)}"
  }
}

resource "aws_route_table" "tgw" {
  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_main_route_table_association" "tgw" {
  vpc_id         = "${module.vpc.vpc_id}"
  route_table_id = "${aws_route_table.tgw.id}"
}

resource "aws_sns_topic" "windows_events" {
  name = "ri-${var.environment}-windows-events"
}
