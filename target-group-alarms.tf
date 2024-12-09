data "aws_lb_target_group" "target_group" {
  tags = var.unique_tags
}

resource "aws_cloudwatch_metric_alarm" "health_host_alarm" {
  alarm_name                = "TG| ${data.aws_lb_target_group.target_group.name} | Unhealthy Hosts"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "12"
  metric_name               = "HealthyHostCount"
  namespace                 = "AWS/ApplicationELB"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = var.minimum_health_hosts
  alarm_description         = "Unhealthy target group in ${data.aws_lb_target_group.target_group.name}"
  alarm_actions             = var.aws_sns_topic_arn
  ok_actions                = var.aws_sns_topic_arn
  insufficient_data_actions = var.aws_sns_topic_arn
  treat_missing_data        = "breaching"
  dimensions = {
    TargetGroup  = data.aws_lb_target_group.target_group.arn_suffix
    LoadBalancer = split("loadbalancer/", tolist(data.aws_lb_target_group.target_group.load_balancer_arns)[0])[1]
  }
  tags = merge(var.tags, {
    "TargetGroup" = data.aws_lb_target_group.target_group.name,
    "Terraform"   = "true"
  })
}

resource "aws_cloudwatch_metric_alarm" "error_rate_4xx_alarm" {
  alarm_name                = "ALB| ${data.aws_lb_target_group.target_group.name} | 4XX Error Rate"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  threshold                 = var.error_rate_4XX_threshold
  alarm_description         = "4XX Error rate monitoring for ${data.aws_lb_target_group.target_group.name}"
  alarm_actions             = var.aws_sns_topic_arn
  ok_actions                = var.aws_sns_topic_arn
  insufficient_data_actions = var.aws_sns_topic_arn
  treat_missing_data        = "notBreaching"
  tags = merge(var.tags, {
    "TargetGroup" = data.aws_lb_target_group.target_group.name,
    "Terraform"   = "true"
  })
  metric_query {
    id          = "e1"
    expression  = "(FILL(m2,0))/FILL(m1,1)*100"
    label       = "4XX Error Rate"
    return_data = true

  }

  metric_query {
    id = "m1"
    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = 3600
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        TargetGroup  = data.aws_lb_target_group.target_group.arn_suffix
        LoadBalancer = split("loadbalancer/", tolist(data.aws_lb_target_group.target_group.load_balancer_arns)[0])[1]
      }

    }
  }
  metric_query {
    id = "m2"
    metric {
      metric_name = "HTTPCode_Target_4XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = 3600
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        TargetGroup  = data.aws_lb_target_group.target_group.arn_suffix
        LoadBalancer = split("loadbalancer/", tolist(data.aws_lb_target_group.target_group.load_balancer_arns)[0])[1]
      }
    }
  }
}
resource "aws_cloudwatch_metric_alarm" "error_rate_5xx_alarm" {
  alarm_name                = "ALB| ${data.aws_lb_target_group.target_group.name} | 5XX Error Rate"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  threshold                 = var.error_rate_5XX_threshold
  alarm_description         = "5XX Error rate monitoring for ${data.aws_lb_target_group.target_group.name}"
  alarm_actions             = var.aws_sns_topic_arn
  ok_actions                = var.aws_sns_topic_arn
  insufficient_data_actions = var.aws_sns_topic_arn
  treat_missing_data        = "notBreaching"
  tags = merge(var.tags, {
    "TargetGroup" = data.aws_lb_target_group.target_group.name,
    "Terraform"   = "true"
  })
  metric_query {
    id          = "e1"
    expression  = "(FILL(m2,0))/FILL(m1,1)*100"
    label       = "5XX Error Rate"
    return_data = true

  }

  metric_query {
    id = "m1"
    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = 3600
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        TargetGroup  = data.aws_lb_target_group.target_group.arn_suffix
        LoadBalancer = split("loadbalancer/", tolist(data.aws_lb_target_group.target_group.load_balancer_arns)[0])[1]
      }

    }
  }
  metric_query {
    id = "m2"
    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = 3600
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        TargetGroup  = data.aws_lb_target_group.target_group.arn_suffix
        LoadBalancer = split("loadbalancer/", tolist(data.aws_lb_target_group.target_group.load_balancer_arns)[0])[1]
      }
    }
  }
}

