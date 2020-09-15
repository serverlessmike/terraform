output "vpc_env_id" {
  value = "${module.cloudops.vpc_id}"
}

output "env_route53_name_servers" {
  value = "${module.cloudops.route53_name_servers}"
}
