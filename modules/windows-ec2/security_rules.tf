# Add TCP, UDP and ping rules into the security group

resource "aws_security_group_rule" "all_tcp_ports_inbound" {
  count             = "${length(var.tcp_in)}"
  type              = "ingress"
  from_port         = "${element(var.tcp_in,count.index)}"
  to_port           = "${element(var.tcp_in,count.index)}"
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8", "193.105.212.250/32", "80.168.1.186/32", "63.32.42.222/32", "52.212.191.233/32", "63.35.129.51/32"]
  security_group_id = "${aws_security_group.win_default_sg.id}"
}

resource "aws_security_group_rule" "all_udp_ports_inbound" {
  count             = "${length(var.udp_in)}"
  type              = "ingress"
  from_port         = "${length(var.udp_in) > 0 ? element(var.udp_in,count.index) : "0"}"
  to_port           = "${length(var.udp_in) > 0 ? element(var.udp_in,count.index) : "0"}"
  protocol          = "udp"
  cidr_blocks       = ["10.0.0.0/8", "193.105.212.250/32", "80.168.1.186/32", "63.32.42.222/32", "52.212.191.233/32", "63.35.129.51/32"]
  security_group_id = "${aws_security_group.win_default_sg.id}"
}

resource "aws_security_group_rule" "all_tcp_ports_outbound" {
  count             = "${length(var.tcp_out)}"
  type              = "egress"
  from_port         = "${element(var.tcp_out,count.index)}"
  to_port           = "${element(var.tcp_out,count.index)}"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.win_default_sg.id}"
}

resource "aws_security_group_rule" "all_udp_ports_outbound" {
  count             = "${length(var.udp_out)}"
  type              = "egress"
  from_port         = "${length(var.udp_out) > 0 ? element(var.udp_out,count.index) : "0"}"
  to_port           = "${length(var.udp_out) > 0 ? element(var.udp_out,count.index) : "0"}"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.win_default_sg.id}"
}

resource "aws_security_group_rule" "allow_pings_inbound" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.win_default_sg.id}"
}

resource "aws_security_group_rule" "allow_pings_outbound" {
  type              = "egress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.win_default_sg.id}"
}
