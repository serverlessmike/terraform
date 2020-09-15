resource "aws_key_pair" "default" {
  key_name   = "${var.project_name}-${var.environment}-default"
  public_key = "${file("${path.root}/${var.aws_ssh_key_file}.pub")}"
}

resource "aws_kms_key" "cloudops_concourse_ci" {}

resource "aws_kms_alias" "cloudops_concourse_ci" {
  name          = "alias/cloudops_concourse_ci"
  target_key_id = "${aws_kms_key.cloudops_concourse_ci.key_id}"
}

output "aws_kms_key_cloudops_concourse_ci" {
  value = "${aws_kms_key.cloudops_concourse_ci.arn}"
}
