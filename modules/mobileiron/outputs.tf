// sentry module

output "sentry_dns" {
  value       = "${module.sentry.sentry_lb_dns}"
  description = "Sentry LB DNS record"
}

// connector module

output "connector_dns" {
  value       = "${module.connector.connector_instance_dns}"
  description = "Connector DNS record"
}
