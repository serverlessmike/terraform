output "sentry_lb_dns" {
  value       = "${aws_route53_record.sentry.fqdn}"
  description = "Sentry LB DNS record"
}
