data "aws_ami" "sentry" {
  most_recent = false

  filter {
    name   = "name"
    values = ["RI Sentry ${var.sentry_version} AWS"]
  }

  owners = ["${var.ami_account_id}"]
}

resource "aws_launch_configuration" "sentry" {
  image_id        = "${data.aws_ami.sentry.id}"
  instance_type   = "t3.large"
  key_name        = "${var.ssh_key_name}"
  security_groups = ["${var.security_groups}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "sentry" {
  name                 = "${var.product_name}-asg"
  vpc_zone_identifier  = ["${var.private_subnets}"]
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.sentry.name}"
  target_group_arns    = ["${aws_lb_target_group.default.arn}", "${aws_lb_target_group.mgmt.arn}"]

  tags = ["${concat(
      list(map("key", "Name", "value", "${var.project_name_tag}-${var.product_name}", "propagate_at_launch", true)),
      var.tags,
      local.tags_asg_format
   )}"]
}
