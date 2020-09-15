module "sentry" {
  source = "./sentry"

  environment     = "${var.environment}"
  ssh_key_name    = "${var.ssh_key_name}"
  vpc_id          = "${var.vpc_id}"
  public_subnets  = "${var.private_subnets}"
  private_subnets = "${var.public_subnets}"
  r53_zone_id     = "${var.r53_zone_id}"

  ami_account_id = "${var.ami_account_id}"
  sentry_version = "${var.sentry_version}"

  tags_as_map = {
    repo        = "cloudops-terraform"
    environment = "${var.environment}"
    terraform   = "true"
    tf_module   = "mobileiron/sentry"
  }

  security_groups = ["${aws_security_group.allow_ssh.id}", "${aws_security_group.sentry.id}"]
}
