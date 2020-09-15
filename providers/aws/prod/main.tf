terraform {
  backend "s3" {
    bucket = "prod-cloudops-tf-state"
    key    = "infrastructure/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "2.1.0"

  allowed_account_ids = ["795357751823"]
}

module "cloudops" {
  source = "../../../modules/cloudops"

  environment     = "prod"
  private_subnets = ["10.202.176.0/24", "10.202.177.0/24", "10.202.178.0/24"]
  public_subnets  = ["10.202.179.0/24", "10.202.180.0/24", "10.202.181.0/24"]
  vpc_cidr        = "10.202.176.0/21"
  vpc_tgw_subnets = ["10.202.182.16/28", "10.202.182.32/28", "10.202.182.48/28"]

  enable_vpn                         = true
  propagate_private_route_tables_vgw = true
}

resource "aws_route" "styleman" {
  route_table_id            = "rtb-05d64016955af832a"
  destination_cidr_block    = "10.202.96.0/22"
  vpc_peering_connection_id = "pcx-0899d6cd26f74f491"

}
module "vpn" {
  source = "../../../modules/vpn"

  environment             = "prod"
  cgw_ip                  = "193.105.212.250"
  vpc_id                  = "${module.cloudops.vpc_id}"
  vpn_vgw_id              = "${module.cloudops.vpn_gw_id}"
  private_route_table_ids = "${module.cloudops.private_route_table_ids}"
}

module "mobileiron" {
  source = "../../../modules/mobileiron"

  environment     = "prod"
  ssh_key_name    = "cloudops-prod-default"
  vpc_id          = "${module.cloudops.vpc_id}"
  public_subnets  = "${module.cloudops.private_subnet_ids}"
  private_subnets = "${module.cloudops.public_subnet_ids}"
  r53_zone_id     = "${module.cloudops.route53_zone_id}"

  ami_account_id = "795357751823" // Mobile Iron AWS AMI Account ID
  sentry_version = "9.4.0.4"      // Sentry version for AMI
  connector_ami  = "ami-c8d9d222" //Connector AMI from Mobile Iron

  tags_as_map = {
    repo        = "cloudops-terraform"
    environment = "prod"
    terraform   = true
    tf_module   = "mobileiron"
  }
}

# Add in audit (actually just the bucket for now)

module "audit" {
  source = "../../../modules/audit"

  environment = "prod"
}

module "StatefulWinEC2" {
  source = "../../../modules/stateful-ec2"

  # These parameters are specific to the environment
  environment        = "prod"
  private_subnet_ids = "${join(",",module.cloudops.private_subnet_ids)}"
  public_subnet_ids  = "${join(",",module.cloudops.public_subnet_ids)}"

  # The following are product-specific
  is_public             = ["false", "false", "false", "false"]
  products              = ["cid", "mksql", "newcid", "maxs"]
  ami_versions          = ["Base-2020.02.12", "SQL_2019_Standard-2019.12.16", "SQL_2019_Standard-2019.12.16", "SQL_2017_Standard-2019.12.16"]
  owners                = ["MOBA", "DBAs", "MOBA", "DBAs"]
  instance_types        = ["m5.xlarge", "m5.xlarge", "m5.xlarge", "m5.xlarge"]
  min_size              = ["1", "0", "1", "1"]
  des_size              = ["1", "0", "1", "1"]
  max_size              = ["1", "1", "1", "1"]
  customisation_scripts = ["cid.ps1", "mksql.ps1", "cid2.ps1", "maxs.ps1"]
  backup_intervals      = ["12", "12", "12", "24"]
  backups_retained      = ["14", "14", "14", "2"]
  backup_start_times    = ["02:00", "02:00", "02:00", "02:00"]
  allow_1433_in         = ["cid", "mksql", "newcid", "maxs"]
  allow_1434_in         = ["cid", "mksql", "newcid", "maxs"]
  allow_rdp_in          = ["cid", "mksql", "newcid", "maxs"]
  allow_ssh_in          = ["cid", "mksql", "newcid", "maxs"]
}
