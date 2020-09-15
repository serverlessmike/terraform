terraform {
  backend "s3" {
    bucket = "management-cloudops-tf-state"
    key    = "infrastructure/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "= 1.57.0"

  allowed_account_ids = ["224889443659"]
}

module "management" {
  source = "../../../modules/management"
}
