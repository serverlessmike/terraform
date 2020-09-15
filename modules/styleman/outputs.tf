output "aws_kms_key_styleman" {
  value = "${aws_kms_key.styleman.arn}"
}

output "minor_alerts_sns" {
  value = "${aws_sns_topic.minor_alerts.arn}"
}
