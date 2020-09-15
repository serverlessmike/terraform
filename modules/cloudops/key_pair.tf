resource "aws_key_pair" "default" {
  key_name   = "${var.project_name}-${var.environment}-default"
  public_key = "${file("${path.root}/default.pub")}"
}
