resource "aws_lb" "default" {
  name               = "${var.project_name_tag}-${var.product_name}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${var.public_subnets}"]

  tags = {
    Name         = "${var.project_name_tag}-${var.product_name}-nlb"
    repo         = "cloudops-terraform"
    environment  = "${var.environment}"
    terraform    = "true"
    tf_module    = "mobileiron/sentry"
    project_name = "${var.project_name}"
  }
}

resource "aws_lb_listener" "ssl_listener" {
  load_balancer_arn = "${aws_lb.default.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.default.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "default" {
  name                 = "${var.product_name}-tg"
  port                 = 443
  protocol             = "TCP"
  deregistration_delay = 20
  vpc_id               = "${var.vpc_id}"
  target_type          = "instance"

  health_check {
    interval            = 30
    unhealthy_threshold = 3
    healthy_threshold   = 3
    protocol            = "TCP"
    port                = "traffic-port"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name         = "${var.product_name}-tg"
    repo         = "cloudops-terraform"
    environment  = "${var.environment}"
    terraform    = "true"
    tf_module    = "mobileiron/sentry"
    project_name = "${var.project_name}"
  }
}

resource "aws_lb_listener" "mgmt" {
  load_balancer_arn = "${aws_lb.default.arn}"
  port              = "8443"
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.mgmt.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "mgmt" {
  name                 = "${var.product_name}-mgmt-tg"
  port                 = 8443
  protocol             = "TCP"
  deregistration_delay = 20
  vpc_id               = "${var.vpc_id}"
  target_type          = "instance"

  health_check {
    interval            = 30
    unhealthy_threshold = 3
    healthy_threshold   = 3
    protocol            = "TCP"
    port                = "traffic-port"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name         = "${var.product_name}-mgmt-tg"
    repo         = "cloudops-terraform"
    environment  = "${var.environment}"
    terraform    = "true"
    tf_module    = "mobileiron/sentry"
    project_name = "${var.project_name}"
  }
}
