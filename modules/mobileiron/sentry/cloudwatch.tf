resource "aws_cloudwatch_metric_alarm" "Sentry-UnhealthyHost" {
  alarm_name          = "${var.product_name}-UnhealthyHost"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/NetworkELB"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "1.0"
  alarm_description   = "Unhealthy target has been identified in the ${aws_lb_target_group.default.name}"

  dimensions {
    TargetGroup  = "${aws_lb_target_group.default.arn_suffix}"
    LoadBalancer = "${aws_lb.default.arn_suffix}"
  }
}
