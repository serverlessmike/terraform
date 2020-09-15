// vpc.tf outputs
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr_block" {
  value = "${module.vpc.vpc_cidr_block}"
}

output "private_route_table_ids" {
  value = ["${module.vpc.private_route_table_ids}"]
}

// route_53.tf outputs
output "route53_name_servers" {
  value = "${aws_route53_zone.environment.name_servers}"
}

output "private_subnet_ids" {
  value = "${module.vpc.private_subnets}"
}

output "public_subnet_ids" {
  value = "${module.vpc.public_subnets}"
}

output "nat_public_ips" {
  value = "${module.vpc.nat_public_ips}"
}

output "route53_zone_id" {
  value = "${aws_route53_zone.environment.zone_id}"
}

output "key_name" {
  value = "${aws_key_pair.default.key_name}"
}

output "vpn_gw_id" {
  value = "${module.vpc.vgw_id}"
}

output "win_event_topic" {
  value = "${aws_sns_topic.windows_events.arn}"
}
