output "sg_name" {
  value = "${aws_security_group.active_directory_sg.name}"
}

output "sg_id" {
  value = "${aws_security_group.active_directory_sg.id}"
}
