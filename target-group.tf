resource "aws_cloudwatch_metric_alarm" "health_alarm" {
  alarm_name                = "TargetGroup-${var.target_group_name}-not-healthy"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "12"
  metric_name               = "HealthyHostCount"
  namespace                 = "AWS/ApplicationELB"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = var.target_group_threshold
  alarm_description         = "Health target group in ${var.target_group_name} is unhealthy"
  alarm_actions             = [var.aws_sns_topic_arn]
  ok_actions                = [var.aws_sns_topic_arn]
  insufficient_data_actions = []
  dimensions = {
    TargetGroup  = var.target_group_name
    LoadBalancer = var.load_balancer_name
  }
  tags = merge(var.tags, {
    "TargetGroup" = var.target_group_name,
    "Terraform"   = "true"
  })
}
