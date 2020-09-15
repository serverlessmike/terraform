# Build a bucket to hold scripts, backups etc.

resource "aws_s3_bucket" "bucky" {
  bucket = "ri-enterprise"

  tags {
    environment = "${var.environment}"
    owner       = "mikec"
    terraform   = "true"
    repo        = "cloudops-terraform"
  }

  acl = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_policy" "product_lambda_artifacts_policy" {
  bucket = "${aws_s3_bucket.bucky.id}"
  policy = "${data.aws_iam_policy_document.bucky_polly.json}"
}

data "aws_iam_policy_document" "bucky_polly" {
  statement {
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    principals = {
      type        = "AWS"
      identifiers = ["${formatlist("arn:aws:iam::%s:root", compact(var.all_enterprise_account_ids))}"]
    }

    resources = [
      "${aws_s3_bucket.bucky.arn}/*",
      "${aws_s3_bucket.bucky.arn}",
    ]
  }
}
