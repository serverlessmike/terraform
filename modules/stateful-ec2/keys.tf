# Produces a key pair per environment for each product

resource "aws_key_pair" "default" {
  count      = "${length(var.products)}"
  key_name   = "${element(var.products,count.index)}_${var.environment}"
  public_key = "${file("${path.root}/keys/${element(var.products,count.index)}_${var.environment}.pub")}"
}
