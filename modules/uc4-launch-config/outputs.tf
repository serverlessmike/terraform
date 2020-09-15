output "elb_name" {
  value = "${module.elb.this_elb_name}"
}

output "elb_id" {
  value = "${module.elb.this_elb_id}"
}

output "elb_arn" {
  value = "${module.elb.this_elb_arn}"
}

output "elb_dns_name" {
  value = "${module.elb.this_elb_dns_name}"
}
