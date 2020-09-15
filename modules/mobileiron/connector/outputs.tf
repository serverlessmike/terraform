output "connector_instance_dns" {
  value       = "${aws_route53_record.connector.fqdn}"
  description = "Connector DNS record"
}
