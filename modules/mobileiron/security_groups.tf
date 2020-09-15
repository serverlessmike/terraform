// SSH secuirty Group
resource "aws_security_group" "allow_ssh" {
  name        = "${var.project_name_tag}-allow-ssh"
  description = "Allow ssh traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name         = "${var.project_name_tag}-allow-ssh"
    repo         = "cloudops-terraform"
    environment  = "prod"
    terraform    = "true"
    tf_module    = "mobileiron"
    project_name = "${var.project_name}"
  }
}

// Sentry security group
resource "aws_security_group" "sentry" {
  name        = "${var.project_name_tag}-sentry"
  description = "Allow sentry traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name         = "${var.project_name_tag}-sentry"
    repo         = "cloudops-terraform"
    environment  = "prod"
    terraform    = "true"
    tf_module    = "mobileiron"
    project_name = "${var.project_name}"
  }
}

// Connector security group
resource "aws_security_group" "connector" {
  name        = "${var.project_name_tag}-connector"
  description = "Allow connector traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "-1"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name         = "${var.project_name_tag}-connector"
    repo         = "cloudops-terraform"
    environment  = "prod"
    terraform    = "true"
    tf_module    = "mobileiron"
    project_name = "${var.project_name}"
  }
}
