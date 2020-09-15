terraform {
  backend "s3" {
    bucket = "dev-cloudops-tf-state"
    key    = "infrastructure/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "= 1.46.0"

  allowed_account_ids = ["092941714243"]
}

module "cloudops" {
  source = "../../../modules/cloudops"

  environment     = "dev"
  private_subnets = ["10.200.184.0/24", "10.200.185.0/24", "10.200.186.0/24"]
  public_subnets  = ["10.200.187.0/24", "10.200.188.0/24", "10.200.189.0/24"]
  vpc_cidr        = "10.200.184.0/21"
  vpc_tgw_subnets = ["10.200.190.16/28", "10.200.190.32/28", "10.200.190.48/28"]
}

module "BuildBucket" {
  environment                = "dev"
  source                     = "../../../modules/object-store"
  all_enterprise_account_ids = ["092941714243", "558469419837", "795357751823"]
}
