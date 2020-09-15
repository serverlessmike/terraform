data "aws_region" "current" {}

module "concourse4" {
  source                       = "git::ssh://git@github.com/river-island/core-infrastructure-terraform.git//modules/concourse4?ref=0b19d6800d2201be6d1ddb36c4d360eef98f28e8"
  project_name                 = "${var.project_name}"
  project_domain               = "io"
  environment                  = "${var.environment}"
  vpc_id                       = "${module.vpc.vpc_id}"
  public_subnets               = "${module.vpc.public_subnets}"
  private_subnets              = "${module.vpc.private_subnets}"
  vpc_subnet                   = "${var.vpc_cidr}"
  ec2_key_pair                 = "${aws_key_pair.default.key_name}"
  postgres_multi_az            = "false"
  postgres_skip_final_snapshot = "false"
  kms_key_arn                  = "${aws_kms_key.cloudops_concourse_ci.arn}"
  encrypted_keys               = "${var.encrypted_keys}"

  // allow the instance to assume the cd roles in project accounts
  additional_ecs_instance_role_policy = "${file("${path.module}/iam_policies/ecs_instance.json")}"

  // encrypted with kms
  config_basic_auth_encrypted_password = "AQICAHhrVtu+qJzl/lryOxp/tlDSpRVOTPrIA1sX4oLI3mBmRwE0kRdKrtybVMLQXd+xrbkjAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMm3FNY0+VpxktIYykAgEQgDuGKuzNFsh4CdwXEJFCuiOVcmBpYtkgmZHR9SVajSHbs0yb40AtkxEydRqTBBWm6CzxvJtSKkDMCeAT+Q=="
  config_postgres_encrypted_password   = "AQICAHhrVtu+qJzl/lryOxp/tlDSpRVOTPrIA1sX4oLI3mBmRwFzWgSOQFo3/D0H7nY6jDrhAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMB6rTm5vJCrx+p/ZvAgEQgDu+fhuIp2eOt/oqL5EfIZt1hHU7QXnZYFlBuIGSN2PqMLLNhm/hfBeWZN8MDdBs+6t8wEb77U8Yo1HHPA=="
  config_github_auth_client_secret     = "AQICAHhrVtu+qJzl/lryOxp/tlDSpRVOTPrIA1sX4oLI3mBmRwHPP0PjSeUvGMYqu1FK5b7zAAAAhzCBhAYJKoZIhvcNAQcGoHcwdQIBADBwBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDHD2UlFjOSAfmI+UPQIBEIBDnyLXY2311Hw3SOnKzOvApYZDwLpJXVG5aCUIVQWh/r/OcunYrLRtE+AVkf2B/jL25mbAOn5/Mw1tKRJFw861dDOL2g=="
  config_github_auth_client_id         = "013f3c2c9d75d52aa3c4"
  config_external_url                  = "https://concourse4.${var.environment}.${var.project_name}.ri-tech.io"

  config_github_auth_team = "River-Island:cloudops-write"

  # the encrypted values are encrypted with kms.
  web_additional_env_vars = <<EOF
{
  "name": "AWS_REGION",
  "value": "${data.aws_region.current.name}"
},
{
  "name": "CONCOURSE_AWS_SECRETSMANAGER_PIPELINE_SECRET_TEMPLATE",
  "value": "/concourse/{{.Team}}/{{.Pipeline}}/{{.Secret}}"
},
{
  "name": "CONCOURSE_AWS_SECRETSMANAGER_TEAM_SECRET_TEMPLATE",
  "value": "/concourse/{{.Team}}/{{.Secret}}"
}
EOF
}
