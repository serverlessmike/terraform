terraform {
  region = "eu-west-1"
}

provider "aws" {
  region  = "eu-west-1"
  version = "= 1.29.0"
}

module "testy" {
  source      = ".."
  vpc_id      = "vpc-083fc6a8e774c869d"
  environment = "dev"
}
