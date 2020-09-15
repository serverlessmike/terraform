output "env_vpc_id" {
  value = "${module.cloudops.vpc_id}"
}

output "env_route53_name_servers" {
  value = "${module.cloudops.route53_name_servers}"
}

output "env_sentry_fqdn" {
  value = "${module.mobileiron.sentry_dns}"
}

output "env_connector_fqdn" {
  value = "${module.mobileiron.connector_dns}"
}
