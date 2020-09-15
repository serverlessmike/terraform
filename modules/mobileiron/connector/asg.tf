resource "aws_launch_configuration" "connector" {
  image_id        = "${var.connector_ami}"
  instance_type   = "t3.large"
  key_name        = "${var.ssh_key_name}"
  security_groups = ["${var.security_groups}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "connector" {
  name                 = "${var.product_name}-asg"
  vpc_zone_identifier  = ["${var.private_subnets}"]
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.connector.name}"

  tags = ["${concat(
      list(map("key", "Name", "value", "${var.project_name_tag}-${var.product_name}", "propagate_at_launch", true)),
      var.tags,
      local.tags_asg_format
   )}"]
}
