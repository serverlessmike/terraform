data "aws_instances" "connector_ip" {
  instance_tags {
    Name = "${var.project_name_tag}-${var.product_name}"
  }

  instance_state_names = ["running", "pending"]
  depends_on           = ["aws_autoscaling_group.connector"]
}

resource "aws_route53_record" "connector" {
  zone_id = "${var.r53_zone_id}"
  name    = "${var.product_name}"
  type    = "A"
  ttl     = "60"
  records = ["${data.aws_instances.connector_ip.private_ips}"]
}
