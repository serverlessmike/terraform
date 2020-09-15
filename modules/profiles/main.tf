// S3 policies

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  role = "${aws_iam_role.s3_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:List*"
      ],
      "Resource": "*"
    }
  ]
}

EOF
}

resource "aws_iam_role" "s3_role" {
  name = "s3_role"

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

// CW policies

resource "aws_iam_role_policy" "cw_policy" {
  name = "cw_policy"
  role = "${aws_iam_role.cw_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "autoscaling:Describe*",
        "cloudwatch:*",
        "logs:*",
        "sns:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "cw_role" {
  name = "cw_role"

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

// SNAPSHOT ROLE

resource "aws_iam_role_policy" "snap1_policy" {
  name = "snap1_policy"
  role = "${aws_iam_role.snap_role1.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:RebootInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances",
        "ec2:CreateSnapshot",
        "ec2:CreateImage",
        "ec2:CreateTags",
        "ec2:DeleteSnapshot",
        "ec2:DeregisterImage"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "snap_role1" {
  name = "snap_role1"

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

########### TO KEEP ##########
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "",
#      "Effect": "Allow",
#      "Principal": {
#        "Service": "automation.amazonaws.com"
#      },
#      "Action": "sts:AssumeRole"
#    }
#  ]
#}
#EOF
#}
##############################

// ATTACHING

resource "aws_iam_instance_profile" "s3_profile" {
  name = "s3_profile"
  role = "${aws_iam_role.s3_role.name}"
}

resource "aws_iam_instance_profile" "cw_profile" {
  name = "cw_profile"
  role = "${aws_iam_role.cw_role.name}"
}

resource "aws_iam_instance_profile" "snap1_profile" {
  name = "snap1_profile"
  role = "${aws_iam_role.snap_role1.name}"
}

// OUTPUT

output "ec2_profile_s3" {
  value = "${aws_iam_instance_profile.s3_profile.id}"
}

output "ec2_profile_cw" {
  value = "${aws_iam_instance_profile.cw_profile.id}"
}

output "ec2_profile_snap1" {
  value = "${aws_iam_instance_profile.snap1_profile.id}"
}
