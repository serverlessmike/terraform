resource "aws_route53_record" "sentry" {
  zone_id = "${var.r53_zone_id}"
  name    = "${var.product_name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_lb.default.dns_name}"]
}
