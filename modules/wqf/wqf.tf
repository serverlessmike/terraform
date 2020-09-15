resource "aws_instance" "wqf_inst" {
  ami               = "${data.aws_ami.wqf.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  instance_type     = "m5a.4xlarge"
  key_name          = "wqf"

  get_password_data      = "true"
  monitoring             = "true"
  vpc_security_group_ids = ["${aws_security_group.allow_rdp_ping.id}"]

  subnet_id                   = "${data.aws_subnet_ids.privates.ids[0]}"
  associate_public_ip_address = "false"

  tags {
    Name        = "wqf-${var.environment}"
    product     = "wqf"
    terraform   = true
    repo        = "cloudops-terraform"
    environment = "${var.environment}"
    owner       = "DBAs"
  }

  ebs_block_device {
    device_name           = "xvdb"
    snapshot_id           = ""
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  volume_tags {
    product     = "wqf"
    terraform   = true
    repo        = "cloudops-terraform"
    environment = "${var.environment}"
    owner       = "DBAs"
  }
}
