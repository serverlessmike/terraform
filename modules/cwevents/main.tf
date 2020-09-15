// CHANGING STATE EVENT

resource "aws_cloudwatch_event_rule" "changestate" {
  name        = "changestate"
  description = "Capture each EC2 changing state"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "EC2 Instance State-change Notification"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "changestate" {
  rule      = "${aws_cloudwatch_event_rule.changestate.name}"
  target_id = "SendToSNS"
  arn       = "${aws_sns_topic.cwevents.arn}"
}

resource "aws_sns_topic" "cwevents" {
  name = "cwevents"
}

// CW ELB

variable "wmselbname" {
  default = ""
}

resource "aws_cloudwatch_metric_alarm" "metric-elb" {
  alarm_name          = "metric-elb"
  alarm_description   = "alarm attached to the ELB"
  metric_name         = "HealthyHostCount"
  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "0"
  statistic           = "Minimum"
  evaluation_periods  = "1"
  period              = "300"
  namespace           = "AWS/ELB"

  dimensions = {
    "LoadBalancerName" = "${var.wmselbname}"
  }

  actions_enabled           = "true"
  alarm_actions             = ["${aws_sns_topic.cwevents.arn}"]
  ok_actions                = []
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "metric-elb2" {
  alarm_name          = "metric-elb2"
  alarm_description   = "alarm attached to the ELB"
  metric_name         = "HTTPCode_Backend_5XX"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "10"
  statistic           = "Sum"
  evaluation_periods  = "1"
  period              = "300"
  namespace           = "AWS/ELB"

  dimensions = {
    "LoadBalancerName" = "${var.wmselbname}"
  }

  actions_enabled           = "true"
  alarm_actions             = ["${aws_sns_topic.cwevents.arn}"]
  ok_actions                = []
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "metric-elb3" {
  alarm_name          = "metric-elb3"
  alarm_description   = "alarm attached to the ELB"
  metric_name         = "HTTPCode_Backend_4XX"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "10"
  statistic           = "Sum"
  evaluation_periods  = "1"
  period              = "300"
  namespace           = "AWS/ELB"

  dimensions = {
    "LoadBalancerName" = "${var.wmselbname}"
  }

  actions_enabled           = "true"
  alarm_actions             = ["${aws_sns_topic.cwevents.arn}"]
  ok_actions                = []
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "metric-elb4" {
  alarm_name          = "metric-elb4"
  alarm_description   = "alarm attached to the ELB"
  metric_name         = "HTTPCode_ELB_4XX"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "10"
  statistic           = "Sum"
  evaluation_periods  = "1"
  period              = "300"
  namespace           = "AWS/ELB"

  dimensions = {
    "LoadBalancerName" = "${var.wmselbname}"
  }

  actions_enabled           = "true"
  alarm_actions             = ["${aws_sns_topic.cwevents.arn}"]
  ok_actions                = []
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "metric-elb5" {
  alarm_name          = "metric-elb5"
  alarm_description   = "alarm attached to the ELB"
  metric_name         = "HTTPCode_ELB_5XX"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "10"
  statistic           = "Sum"
  evaluation_periods  = "1"
  period              = "300"
  namespace           = "AWS/ELB"

  dimensions = {
    "LoadBalancerName" = "${var.wmselbname}"
  }

  actions_enabled           = "true"
  alarm_actions             = ["${aws_sns_topic.cwevents.arn}"]
  ok_actions                = []
  insufficient_data_actions = []
}
