# Creates Windows Server instances in auto-scaling groups
# based on Amazon's images
# The instances are based on a template and each ASG is given its own customisable security group
# As an instance boots it is able to customise its config using a script it collects from a bucket (if required)

resource "aws_launch_template" "win_templates" {
  name = "${var.product}_${var.environment}"

  monitoring {
    enabled = true
  }

  instance_type          = "${var.instance_type}"
  description            = "Template for ${var.product}"
  image_id               = "${data.aws_ami.windows_server.id}"
  key_name               = "${aws_key_pair.defaults.key_name}"
  vpc_security_group_ids = ["${aws_security_group.win_default_sg.id}"]

  tags = {
    Name        = "${var.product}_${var.environment}"
    owner       = "${var.owner}"
    type        = "stateful"
    repo        = "cloudops-terraform"
    product     = "${var.product}"
    terraform   = true
    environment = "${var.environment}"
  }

  placement {
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
  }

  user_data = "${base64encode(data.template_file.user_data.rendered)}"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.win_ec2_profile.name}"
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name        = "${var.product}-C-drive"
      drive       = "C"
      owner       = "${var.owner}"
      type        = "OS"
      repo        = "cloudops-terraform"
      product     = "${var.product}"
      terraform   = true
      environment = "${var.environment}"
    }
  }
}

resource "aws_autoscaling_group" "win_servers" {
  name                = "${var.product}"
  min_size            = "${var.min_size}"
  desired_capacity    = "${var.des_size}"
  max_size            = "${var.max_size}"
  health_check_type   = "EC2"
  vpc_zone_identifier = ["${split(",",var.is_public ? var.public_subnet_ids : var.private_subnet_ids)}"]
  target_group_arns   = ["${aws_lb_target_group.secure_shell.arn}", "${aws_lb_target_group.rdp.arn}"]
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceCapacity", "GroupMinSize", "GroupMaxSize", "GroupInServiceInstances", "GroupTotalCapacity", "GroupTotalInstances"]

  tags = [
    {
      key                 = "Name"
      value               = "${var.product}-${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "product"
      value               = "${var.product}"
      propagate_at_launch = true
    },
    {
      key                 = "environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "terraform"
      value               = true
      propagate_at_launch = true
    },
    {
      key                 = "repo"
      value               = "cloudops-terraform"
      propagate_at_launch = true
    },
    {
      key                 = "type"
      value               = "stateful"
      propagate_at_launch = true
    },
    {
      key                 = "owner"
      value               = "${var.owner}"
      propagate_at_launch = true
    },
    {
      key                 = "custom"
      value               = "${var.customisation_script}"
      propagate_at_launch = true
    },
  ]

  launch_template {
    id      = "${aws_launch_template.win_templates.id}"
    version = "$Latest"
  }
}

resource "aws_security_group" "win_default_sg" {
  name        = "${var.product}_${var.environment}"
  description = "Default security group for ${var.product}"
  vpc_id      = "${data.aws_subnet.mine.vpc_id}"

  tags {
    owner       = "${var.owner}"
    terraform   = "true"
    repo        = "cloudops-terraform"
    environment = "${var.environment}"
    product     = "${var.product}"
  }
}

# Upload the customisation script to a bucket
resource "aws_s3_bucket_object" "ec2_object" {
  bucket = "ri-enterprise"
  key    = "${var.environment}/${var.customisation_script}"
  source = "${path.root}/scripts/${var.customisation_script}"
  etag   = "${filemd5("${path.root}/scripts/${var.customisation_script}")}"

  tags {
    owner       = "${var.owner}"
    terraform   = "true"
    repo        = "cloudops-terraform"
    type        = "Powershell"
    environment = "${var.environment}"
    product     = "${var.product}"
  }
}

resource "aws_autoscaling_notification" "scaling_event" {
  group_names = ["${aws_autoscaling_group.win_servers.name}"]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = "${var.topic_arn}"
}
