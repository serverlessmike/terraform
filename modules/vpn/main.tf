module "vpn_gateway" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpn-gateway.git?ref=5c74b0bf908e152460118253af6b901ade66f340"

  vpc_id              = "${var.vpc_id}"
  vpn_gateway_id      = "${var.vpn_vgw_id}"
  customer_gateway_id = "${aws_customer_gateway.main.id}"

  vpc_subnet_route_table_ids = ["${var.private_route_table_ids}"]

  tags = {
    name         = "${var.environment}-${var.project_name}-vpn"
    repo         = "cloudops-terraform"
    environment  = "${var.environment}"
    terraform    = "true"
    tf_module    = "vpn"
    project_name = "${var.project_name}"
  }
}

resource "aws_customer_gateway" "main" {
  bgp_asn    = 65000
  ip_address = "${var.cgw_ip}"
  type       = "ipsec.1"

  tags = {
    name         = "${var.environment}-${var.project_name}-cgw"
    repo         = "cloudops-terraform"
    environment  = "${var.environment}"
    terraform    = "true"
    tf_module    = "vpn"
    project_name = "${var.project_name}"
  }
}

//resource "aws_vpn_gateway" "vpn_gateway" {
//  vpc_id = "${var.vpc_id}"
//
//  tags = {
//    name         = "${var.environment}-${var.project_name}-vpn_gateway"
//    repo         = "cloudops-terraform"
//    environment  = "${var.environment}"
//    terraform    = "true"
//    tf_module    = "vpn"
//    project_name = "${var.project_name}"
//  }
//}
//
//resource "aws_route" "vpn_route" {
//  count = "${length(var.private_route_table_ids)}"
//
//  route_table_id         = "${element(var.private_route_table_ids, count.index)}"
//  gateway_id             = "${aws_vpn_gateway.vpn_gateway.id}"
//  destination_cidr_block = "10.0.0.0/8"
//}

