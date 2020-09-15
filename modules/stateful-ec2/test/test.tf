terraform {
  region = "eu-west-1"
}

provider "aws" {
  region  = "eu-west-1"
  version = "2.1.0"

  allowed_account_ids = ["092941714243"]
}

module "testy" {
  source                = ".."
  products              = ["test"]
  environment           = "dev"
  private_subnet_ids    = "subnet-05e9c53ea415bf726,subnet-0f581621958a7dc9c"
  public_subnet_ids     = "subnet-05e9c53ea415bf726,subnet-0f581621958a7dc9c"
  is_public             = ["true"]
  ami_versions          = ["SQL_2019_Standard-2019.12.16"]
  owners                = ["myname"]
  instance_types        = ["t3.micro"]
  min_size              = ["1"]
  des_size              = ["1"]
  max_size              = ["1"]
  key_names             = ["mykey"]
  customisation_scripts = ["mksql.ps1"]
  backup_intervals      = ["24"]
  backups_retained      = ["2"]
  backup_start_times    = ["02:00"]
  allow_1433_in         = ["test"]
  allow_1434_in         = ["test"]
  allow_rdp_in          = ["test"]
  allow_ssh_in          = ["test"]
}
