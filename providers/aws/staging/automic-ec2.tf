resource "aws_instance" "automic_instance" {
  ami                    = "ami-03f7c013c9789ba73"
  instance_type          = "t3.xlarge"
  subnet_id              = "subnet-0af23cae65c1356f0"
  private_ip             = "10.200.196.130"
  key_name               = "uc4-app-staging-server"
  vpc_security_group_ids = ["sg-04f4fa2be7a545680"]

  user_data = <<-EOF
              #!/bin/bash
              sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
              sudo service sshd restart
              EOF

  tags = {
    Name = "automic_app_server"
  }
}

resource "aws_eip" "automic_eip" {
  instance = "${aws_instance.automic_instance.id}"
}

resource "aws_route53_record" "automic" {
  zone_id = "${var.zone_id}"
  name    = "automic"
  type    = "A"
  ttl     = "300"
  records = ["10.200.196.130"]
}
