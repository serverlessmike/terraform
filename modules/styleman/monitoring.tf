resource "aws_sns_topic" "minor_alerts" {
  name = "${var.project_name}-minor-alerts"
}

resource "aws_sns_topic" "major_alerts" {
  name = "${var.project_name}-major-alerts"
}

// allow both lambdas to listen on both
resource "aws_lambda_permission" "allow_sns_minor_to_call_slack" {
  statement_id  = "AllowExecutionFromSNSMinorToSlackAlerts"
  action        = "lambda:InvokeFunction"
  function_name = "${module.slack_alerts.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.minor_alerts.arn}"
}

resource "aws_lambda_permission" "allow_sns_major_to_call_slack" {
  statement_id  = "AllowExecutionFromSNSMajorToSlackAlerts"
  action        = "lambda:InvokeFunction"
  function_name = "${module.slack_alerts.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.major_alerts.arn}"
}

resource "aws_sns_topic_subscription" "minor_slack" {
  topic_arn = "${aws_sns_topic.minor_alerts.arn}"
  protocol  = "lambda"
  endpoint  = "${module.slack_alerts.lambda_arn}"
}

resource "aws_sns_topic_subscription" "major_slack" {
  topic_arn = "${aws_sns_topic.major_alerts.arn}"
  protocol  = "lambda"
  endpoint  = "${module.slack_alerts.lambda_arn}"
}

// lambda to send slack alerts
module "slack_alerts" {
  source = "git::ssh://git@github.com/river-island/shared-lambdas.git//terraform/modules/slack_notifications?ref=73c0445e9e67b202982bcdd8745a7c64a9570b08"

  project_name    = "${var.project_name}"
  environment     = "${var.environment}"
  vpc_id          = "${var.vpc_id}"
  private_subnets = "${var.private_subnets}"

  sns_to_slack_channel_mapping = {
    "${var.project_name}-minor-alerts" = "#mon-styleman-${var.environment}"
    "${var.project_name}-major-alerts" = "#mon-styleman-${var.environment}"
  }

  kms_key_alias_arn           = "${aws_kms_key.styleman.arn}"
  encrypted_slack_webhook_url = "${var.sns_encrypted_slack_webhook_url}"

  slack_lambda_version = "0.0.90"
}

resource "aws_cloudwatch_metric_alarm" "vpn_in" {
  alarm_name          = "vpn-data-in"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "TunnelDataIn"
  namespace           = "AWS/VPN"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "256.0"
  alarm_description   = "VPN is processing data in. Potential Direct Connect failover."
  alarm_actions       = ["${aws_sns_topic.major_alerts.arn}"]

  dimensions {
    VpnId = "${var.vpn_connection_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "vpn_out" {
  alarm_name          = "vpn-data-out"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "TunnelDataOut"
  namespace           = "AWS/VPN"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "256.0"
  alarm_description   = "VPN is processing data out. Potential Direct Connect failover."
  alarm_actions       = ["${aws_sns_topic.major_alerts.arn}"]

  dimensions {
    VpnId = "${var.vpn_connection_id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "vpn_state" {
  alarm_name          = "vpn-offline"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "TunnelState"
  namespace           = "AWS/VPN"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1"
  alarm_description   = "VPN is offline."
  alarm_actions       = ["${aws_sns_topic.major_alerts.arn}"]

  dimensions {
    VpnId = "${var.vpn_connection_id}"
  }
}
