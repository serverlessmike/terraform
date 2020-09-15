module "elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "1.4.1"

  name                        = "${var.project_name}-${var.environment}-elb"
  subnets                     = ["${var.private_subnets}"]
  security_groups             = ["${var.elb_sg}"]
  internal                    = "true"
  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"

  listener     = ["${var.listener}"]
  access_logs  = ["${var.access_logs}"]
  health_check = ["${var.health_check}"]

  tags = {
    repo        = "cloudops-terraform"
    environment = "staging"
    terraform   = true
  }
}

# autoscaling
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "2.9.1"

  name                        = "${var.project_name}-${var.environment}-asg"
  lc_name                     = "${var.project_name}-${var.environment}-lc"
  image_id                    = "${var.ami_id_uc4}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.iam_role_profile_name}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${var.asg_sg}"]
  associate_public_ip_address = "false"
  enable_monitoring           = "true"

  asg_name             = "uc4-${var.environment}-asg"
  vpc_zone_identifier  = ["${var.private_subnets}"]
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  desired_capacity     = "${var.desired_capacity}"
  min_elb_capacity     = "${var.min_elb_capacity}"
  load_balancers       = ["${module.elb.this_elb_id}"]
  health_check_type    = "${var.health_check_type}"
  termination_policies = "${var.termination_policies}"

  tags_as_map = {
    repo        = "cloudops-terraform"
    environment = "${var.environment}"
    terraform   = "true"
    retention   = 60
    backup      = "True"
  }
}
