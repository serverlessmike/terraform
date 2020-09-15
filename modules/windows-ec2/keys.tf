# Produces a key pair per environment for each product

resource "aws_key_pair" "defaults" {
  key_name   = "${var.product}_${var.environment}"
  public_key = "${file("${path.root}/keys/${var.product}_${var.environment}.pub")}"
}
