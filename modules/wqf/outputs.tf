output "instance_id" {
  value       = "${aws_instance.wqf_inst.id}"
  description = "The ID of the instance"
}

output "instance_ip" {
  value       = "${aws_instance.wqf_inst.private_ip}"
  description = "The private IP address assigned to the instance"
}
