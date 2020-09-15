output "prod_vpc_peer_connection_id" {
  value = "${module.management.management_to_prod_vpc_peering_connection_id}"
}

output "env_route53_name_servers" {
  value = "${module.management.route53_name_servers}"
}
