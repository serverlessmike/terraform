# This terraform allows us to assign a limited set of allowed actions to the instances

resource "aws_iam_instance_profile" "win_profile" {
  name = "win_profile"
  role = "${aws_iam_role.win_role.name}"
}

resource "aws_iam_role" "win_role" {
  name = "stateful_ec2_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "enterprise_roles_attachments" {
  role       = "${aws_iam_role.win_role.name}"
  policy_arn = "${aws_iam_policy.enterprise_ec2_policy.arn}"
}

resource "aws_iam_policy" "enterprise_ec2_policy" {
  name   = "Allow_AWS_Access_to_EC2s"
  path   = "/"
  policy = "${data.aws_iam_policy_document.enterprise_ec2_policy.json}"
}

data "aws_iam_policy_document" "enterprise_ec2_policy" {
  statement {
    sid = "ListObjectsInBucket"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::ri-enterprise",
    ]
  }

  statement {
    sid = "AllowObjectActions"

    actions = [
      "s3:*Object",
    ]

    resources = [
      "arn:aws:s3:::ri-enterprise/*",
    ]
  }

  statement {
    sid = "AllowCloudWatching"

    actions = [
      "cloudwatch:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "AllowSnapshotting"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeVolumes",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeTags",
      "ec2:CreateVolume",
      "ec2:CreateTags",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
    ]

    resources = [
      "*",
    ]
  }
}
