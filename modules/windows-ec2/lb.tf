# Create a new load balancer
resource "aws_lb" "win" {
  name               = "${var.product}${count.index}"
  load_balancer_type = "network"
  internal           = true
  subnets            = ["${split(",",var.private_subnet_ids)}"]

  tags {
    Name        = "${var.product}${count.index}"
    product     = "${var.product}"
    environment = "${var.environment}"
    terraform   = true
    repo        = "cloudops-terraform"
  }
}

resource "aws_lb_target_group" "secure_shell" {
  name     = "${var.product}-ssh"
  port     = "22"
  protocol = "TCP"
  vpc_id   = "${data.aws_subnet.mine.vpc_id}"
}

resource "aws_lb_listener" "secure_shell" {
  load_balancer_arn = "${aws_lb.win.arn}"
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.secure_shell.arn}"
  }
}

resource "aws_lb_target_group" "rdp" {
  name     = "${var.product}-rdp"
  port     = "3389"
  protocol = "TCP"
  vpc_id   = "${data.aws_subnet.mine.vpc_id}"
}

resource "aws_lb_listener" "rdp" {
  load_balancer_arn = "${aws_lb.win.arn}"
  port              = "3389"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.rdp.arn}"
  }
}

resource "aws_route53_record" "lb_a_record" {
  zone_id = "${var.zone_id}"
  name    = "${var.product}"
  type    = "A"

  alias {
    name                   = "${aws_lb.win.dns_name}"
    zone_id                = "${aws_lb.win.zone_id}"
    evaluate_target_health = true
  }
}
