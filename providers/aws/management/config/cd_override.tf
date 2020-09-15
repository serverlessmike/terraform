terraform {
  backend "s3" {
    bucket   = "management-cloudops-tf-state"
    key      = "infrastructure/terraform.tfstate"
    region   = "eu-west-1"
    role_arn = "arn:aws:iam::224889443659:role/cd"
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "= 1.46.0"

  // only allow terraform to run in this account it
  allowed_account_ids = ["224889443659"]

  assume_role {
    role_arn = "arn:aws:iam::224889443659:role/cd"
  }
}
