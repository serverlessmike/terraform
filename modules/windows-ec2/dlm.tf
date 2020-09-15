# Create a "Data Lifecycle Manager Policy"
# Note that backups are optional, in order to turn them off just set backups_retained to zero

resource "aws_iam_role" "dlm_role" {
  count = "${var.backups_retained > 0 ? 1 : 0}"
  name  = "dlm_role"

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

resource "aws_iam_role_policy" "dlm_policy" {
  count = "${var.backups_retained > 0 ? 1 : 0}"
  name  = "dlm_policy"
  role  = "${aws_iam_role.dlm_role.id}"

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

resource "aws_dlm_lifecycle_policy" "dlm_lf_policy" {
  count              = "${var.backups_retained > 0 ? 1 : 0}"
  description        = "${var.product} DLM lifecycle policy in ${var.environment}"
  execution_role_arn = "${aws_iam_role.dlm_role.arn}"
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "${var.product}_${var.environment}"

      create_rule {
        interval      = "${var.backup_interval}"
        interval_unit = "HOURS"
        times         = ["${var.backup_start_time}"]
      }

      retain_rule {
        count = "${var.backups_retained}"
      }

      copy_tags = true
    }

    target_tags = {
      product = "${var.product}"
    }
  }
}
