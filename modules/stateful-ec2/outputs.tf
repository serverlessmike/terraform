output "stateful_asg_ids" {
  value       = "${aws_autoscaling_group.win2019_servers.*.id}"
  description = "The autoscaling group ids"
}

output "stateful_asg_arns" {
  value       = "${aws_autoscaling_group.win2019_servers.*.arn}"
  description = "The ARNs for the autoscaling groups"
}
