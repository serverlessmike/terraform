module "file_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "1.19.0"

  name                        = "file_server"
  instance_count              = 1
  ami                         = "ami-0a3a4d653d15fd64c"
  instance_type               = "c4.xlarge"
  key_name                    = "${module.cloudops.key_name}"
  vpc_security_group_ids      = ["${module.file_server_sg.this_security_group_id}"]
  subnet_id                   = "${element(module.cloudops.public_subnet_ids, 0)}"
  associate_public_ip_address = "true"
  private_ip                  = "10.202.179.178"

  ebs_block_device = [
    {
      device_name           = "xvdb"
      snapshot_id           = ""
      volume_type           = "gp2"
      volume_size           = 4000
      delete_on_termination = true
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

module "file_server_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "2.17.0"

  name        = "file_server_security_group"
  description = "Security group for file server access"
  vpc_id      = "${module.cloudops.vpc_id}"

  ingress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "10.0.0.0/8,193.105.212.250/32,63.32.42.222/32,52.212.191.233/32,63.35.129.51/32"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "file_downloaders" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "1.19.0"

  name                        = "file_downloader"
  instance_count              = 2
  ami                         = "ami-0469cbc09a3830a6d"
  instance_type               = "t2.medium"
  key_name                    = "${module.cloudops.key_name}"
  vpc_security_group_ids      = ["${module.file_server_sg.this_security_group_id}"]
  subnet_id                   = "${element(module.cloudops.public_subnet_ids, 0)}"
  iam_instance_profile        = "${module.iam_role.profile_name}"
  associate_public_ip_address = "true"

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

# iam role and policy
module "iam_role" {
  source = "../../../modules/ec2-iam-role"

  name        = "rimini_iam_role_policy"
  policy      = "${data.aws_iam_policy_document.instance_profile_policy.json}"
  environment = "prod"
}

module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "0.3.0"

  name                   = "oracle-patches"
  namespace              = "rmni"
  stage                  = "prod"
  user_enabled           = "false"
  allowed_bucket_actions = ["s3:*"]
}
