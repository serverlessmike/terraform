resource "aws_iam_role" "styleman_lambda_role" {
  name = "styleman_lambda_role-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "styleman_lambda_role_policy" {
  name   = "styleman_lambda_role-${var.environment}"
  role   = "${aws_iam_role.styleman_lambda_role.id}"
  policy = "${data.aws_iam_policy_document.styleman_lambda_policy_document.json}"
}

data "aws_iam_policy_document" "styleman_lambda_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:Describe*",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
      "ec2:CreateImage",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:CopyImage",
      "ec2:DeregisterImage",
      "sns:Publish",
      "cloudwatch:*",
      "ce:GetCostAndUsage",
      "events:EnableRule",
      "s3:Get*",
      "s3:List*",
      "s3:Put*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "styleman_lambda_common_policy" {
  name   = "styleman_lambda_common_policy-${var.environment}"
  policy = "${data.aws_iam_policy_document.styleman_lambda_policy_document.json}"
}
