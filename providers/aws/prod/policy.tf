data "aws_iam_policy_document" "instance_profile_policy" {
  statement {
    sid = "AllowStylemanS3"

    actions = [
      "s3:*",
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::rmni-dev-oracle-patches",
      "arn:aws:s3:::rmni-dev-oracle-patches/*",
    ]
  }

  statement {
    sid = "AllowStylemanEC2"

    actions = [
      "ec2:Describe*",
    ]

    effect = "Allow"

    resources = [
      "*",
    ]
  }
}
