# Creates Windows Server 2019 instances in auto-scaling groups
# based on Amazon's images
# The instances are based on a template and each ASG is given its own customisable security group
# As an instance boots it is able to customise its config using a script it collects from a bucket (if required)

resource "aws_launch_template" "stateful_templates" {
  count = "${length(var.products)}"
  name  = "lt_${element(var.products,count.index)}_${var.environment}"

  monitoring {
    enabled = true
  }

  instance_type          = "${element(var.instance_types,count.index)}"
  description            = "Template for creating stateful Windows Server instances"
  image_id               = "${element(data.aws_ami.win2019.*.id,count.index)}"
  key_name               = "${element(aws_key_pair.default.*.key_name,count.index)}"
  vpc_security_group_ids = ["${element(aws_security_group.win_ec2.*.id,count.index)}"]

  tags = {
    Name        = "${element(var.products,count.index)}_${var.environment}"
    owner       = "${element(var.owners,count.index)}"
    type        = "stateful"
    repo        = "cloudops-terraform"
    product     = "${element(var.products,count.index)}"
    terraform   = true
    environment = "${var.environment}"
  }

  placement {
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
  }

  user_data = "${base64encode(data.template_file.userdata.rendered)}"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.win_profile.name}"
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name        = "${element(var.products,count.index)}-C-drive"
      drive       = "C"
      owner       = "${element(var.owners,count.index)}"
      type        = "OS"
      repo        = "cloudops-terraform"
      product     = "${element(var.products,count.index)}"
      terraform   = true
      environment = "${var.environment}"
    }
  }
}

resource "aws_autoscaling_group" "win2019_servers" {
  count               = "${length(var.products)}"
  name                = "${element(var.products,count.index)}_${var.environment}"
  min_size            = "${element(var.min_size,count.index)}"
  desired_capacity    = "${element(var.des_size,count.index)}"
  max_size            = "${element(var.max_size,count.index)}"
  health_check_type   = "EC2"
  vpc_zone_identifier = ["${split(",",element(var.is_public,count.index) ? var.public_subnet_ids : var.private_subnet_ids)}"]
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceCapacity", "GroupMinSize", "GroupMaxSize", "GroupInServiceInstances", "GroupTotalCapacity", "GroupTotalInstances"]

  tags = [
    {
      key                 = "Name"
      value               = "${element(var.products,count.index)}-${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "product"
      value               = "${element(var.products,count.index)}"
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
      value               = "${element(var.owners,count.index)}"
      propagate_at_launch = true
    },
    {
      key                 = "custom"
      value               = "${element(var.customisation_scripts,count.index)}"
      propagate_at_launch = true
    },
  ]

  launch_template {
    id      = "${element(aws_launch_template.stateful_templates.*.id,count.index)}"
    version = "$Latest"
  }
}

resource "aws_security_group" "win_ec2" {
  count       = "${length(var.products)}"
  name        = "${element(var.products,count.index)}"
  description = "Default security group for Windows stateful EC2 instances"
  vpc_id      = "${data.aws_subnet.selected.vpc_id}"

  tags {
    owner       = "${element(var.owners,count.index)}"
    terraform   = "true"
    repo        = "cloudops-terraform"
    environment = "${var.environment}"
    product     = "${element(var.products,count.index)}"
  }
}

# Upload the customisation script to a bucket
resource "aws_s3_bucket_object" "object" {
  count  = "${length(var.products)}"
  bucket = "ri-enterprise"
  key    = "${var.environment}/${element(var.customisation_scripts,count.index)}"
  source = "${path.module}/scripts/${var.environment}/${element(var.customisation_scripts,count.index)}"
  etag   = "${filemd5("${path.module}/scripts/${var.environment}/${element(var.customisation_scripts,count.index)}")}"

  tags {
    owner       = "${element(var.owners,count.index)}"
    terraform   = "true"
    repo        = "cloudops-terraform"
    type        = "Powershell"
    environment = "${var.environment}"
    product     = "${element(var.products,count.index)}"
  }
}
