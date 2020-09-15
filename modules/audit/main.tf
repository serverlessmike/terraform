# This tf creates a bucket for the audit
# The audit will eventually be run every morning by every account
# It will drop *describe-service* style JSON objects into the bucket 

resource "aws_s3_bucket" "audit" {
  bucket = "ri-aws-audit"

  tags = {
    terraform      = "true"
    repo           = "cloudops-terraform"
    environment    = "${var.environment}"
    tf-module      = "audit"
    product        = "audit"
    Name           = "ri-aws-audit"
    cost_centre    = "81183"
    security_class = "public"
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "audit/"

    tags {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = 31
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 366
    }
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "AllowPutObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:PutObject*",
            "Resource": "arn:aws:s3:::ri-aws-audit/audit/*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalOrgID": "o-c4oji0v6wu"
                }
            }
        },
        {
          "Sid":"AllowCloudOpsAccess",
          "Effect":"Allow",
          "Principal": {"AWS": ["arn:aws:iam::092941714243:root", "arn:aws:iam::224889443659:root", "arn:aws:iam::558469419837:root", "arn:aws:iam::795357751823:root"]},
          "Action": "s3:*",
          "Resource":["arn:aws:s3:::ri-aws-audit/*"]
        }
     ]
}
POLICY
}
