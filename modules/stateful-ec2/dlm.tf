# Create a "Data Lifecycle Manager Policy"
# Note that every instance has a policy, even in development

resource "aws_iam_role" "dlm_lifecycle_role" {
  name = "dlm_lifecycle_role"

  tags = {
    owner       = "cloudops"
    type        = "RIManaged"
    repo        = "cloudops-terraform"
    product     = "all-stateful"
    terraform   = true
    environment = "${var.environment}"
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "dlm.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dlm_lifecycle" {
  name = "dlm_lifecycle_policy"
  role = "${aws_iam_role.dlm_lifecycle_role.id}"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Action": [
            "ec2:CreateSnapshot",
            "ec2:CreateSnapshots",
            "ec2:DeleteSnapshot",
            "ec2:DescribeInstances",
            "ec2:DescribeVolumes",
            "ec2:DescribeSnapshots"
         ],
         "Resource": "*"
      },
      {
         "Effect": "Allow",
         "Action": [
            "ec2:CreateTags"
         ],
         "Resource": "arn:aws:ec2:*::snapshot/*"
      }
   ]
}
EOF
}

resource "aws_dlm_lifecycle_policy" "dlm" {
  count              = "${length(var.products)}"
  description        = "${element(var.products,count.index)} DLM lifecycle policy ${var.environment}"
  execution_role_arn = "${aws_iam_role.dlm_lifecycle_role.arn}"
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "${element(var.products,count.index)} ${var.environment}"

      create_rule {
        interval      = "${element(var.backup_intervals,count.index)}"
        interval_unit = "HOURS"
        times         = ["${element(var.backup_start_times,count.index)}"]
      }

      retain_rule {
        count = "${element(var.backups_retained,count.index)}"
      }

      copy_tags = true
    }

    target_tags = {
      product = "${element(var.products,count.index)}"
    }
  }
}
