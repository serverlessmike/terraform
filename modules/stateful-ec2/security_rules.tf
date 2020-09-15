# Every instance gets its own (minimal) security group
# Add rules to the security group by adding the product to the appropriate list

data "aws_security_groups" "allow_1433" {
  depends_on = ["aws_security_group.win_ec2"]

  filter {
    name   = "group-name"
    values = ["${var.allow_1433_in}"]
  }
}

resource "aws_security_group_rule" "sql_server_ingress" {
  count             = "${length(var.allow_1433_in)}"
  type              = "ingress"
  from_port         = "1433"
  to_port           = "1433"
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${element(data.aws_security_groups.allow_1433.ids,count.index)}"
}

data "aws_security_groups" "allow_1434" {
  depends_on = ["aws_security_group.win_ec2"]

  filter {
    name   = "group-name"
    values = ["${var.allow_1434_in}"]
  }
}

resource "aws_security_group_rule" "sql_server_admin_ingress" {
  count             = "${length(var.allow_1434_in)}"
  type              = "ingress"
  from_port         = "1434"
  to_port           = "1434"
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${element(data.aws_security_groups.allow_1434.ids,count.index)}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
  count             = "${length(var.products)}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${element(aws_security_group.win_ec2.*.id,count.index)}"
}

resource "aws_security_group_rule" "allow_ping_in" {
  count             = "${length(var.products)}"
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${element(aws_security_group.win_ec2.*.id,count.index)}"
}

data "aws_security_groups" "allow_rdp" {
  depends_on = ["aws_security_group.win_ec2"]

  filter {
    name   = "group-name"
    values = ["${var.allow_rdp_in}"]
  }
}

resource "aws_security_group_rule" "allow_rdp_inbound" {
  # RDP
  count             = "${length(var.products)}"
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${element(data.aws_security_groups.allow_rdp.ids,count.index)}"
}

data "aws_security_groups" "allow_ssh" {
  depends_on = ["aws_security_group.win_ec2"]

  filter {
    name   = "group-name"
    values = ["${var.allow_ssh_in}"]
  }
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
  # RDP
  count             = "${length(var.products)}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = "${element(data.aws_security_groups.allow_ssh.ids,count.index)}"
}
