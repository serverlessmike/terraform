terraform {
  region = "eu-west-1"
}

provider "aws" {
  region  = "eu-west-1"
  version = "= 1.29.0"

  allowed_account_ids = ["092941714243"]
}

module "ebs" {
  source       = ".."
  product      = "test"
  environment  = "dev"
  owner        = ["myname"]
  drives       = ["D"]
  volume_sizes = ["10"]
  instance_id  = "my_instance_ID"
}
