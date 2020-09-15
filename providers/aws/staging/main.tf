terraform {
  backend "s3" {
    bucket = "staging-cloudops-tf-state"
    key    = "infrastructure/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "= 2.1.0"

  allowed_account_ids = ["558469419837"]
}

module "cloudops" {
  source = "../../../modules/cloudops"

  environment     = "staging"
  private_subnets = ["10.200.192.0/24", "10.200.193.0/24", "10.200.194.0/24"]
  public_subnets  = ["10.200.195.0/24", "10.200.196.0/24", "10.200.197.0/24"]
  vpc_cidr        = "10.200.192.0/21"
  vpc_tgw_subnets = ["10.200.198.16/28", "10.200.198.32/28", "10.200.198.48/28"]

  enable_vpn                         = true
  propagate_private_route_tables_vgw = true
}

module "vpn" {
  source = "../../../modules/vpn"

  environment             = "staging"
  cgw_ip                  = "193.105.212.250"
  vpc_id                  = "${module.cloudops.vpc_id}"
  vpn_vgw_id              = "${module.cloudops.vpn_gw_id}"
  private_route_table_ids = "${module.cloudops.private_route_table_ids}"
}
