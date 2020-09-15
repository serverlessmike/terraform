module "ecr" {
  source = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git///modules/ecr_repositories?ref=145556b7c9bd08c73c27b6d55e4b127b1840b43f"

  repository_names    = ["cloudops-ci", "cloudops-zabbix"]
  allowed_account_ids = ["092941714243", "224889443659", "795357751823", "558469419837"]
}
