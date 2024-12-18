data "aws_lb_target_group" "target_group" {
  tags = var.unique_tags
}

resource "aws_cloudwatch_metric_alarm" "health_host_alarm" {
  count                     = var.minimum_health_hosts_enabled ? 1 : 0
  alarm_name                = "ALB | Unhealthy Hosts (<${var.minimum_health_hosts}) | ${data.aws_lb_target_group.target_group.name}"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = 5
  datapoints_to_alarm       = 4
  metric_name               = "HealthyHostCount"
  namespace                 = "AWS/ApplicationELB"
  period                    = 300
  statistic                 = "Average"
  threshold                 = var.minimum_health_hosts
  alarm_description         = "Unhealthy target group in ${data.aws_lb_target_group.target_group.name}"
  alarm_actions             = concat(var.minimum_health_hosts_sns_topics_arns, var.global_sns_topics_arns)
  ok_actions                = concat(var.minimum_health_hosts_sns_topics_arns, var.global_sns_topics_arns)
  insufficient_data_actions = concat(var.minimum_health_hosts_sns_topics_arns, var.global_sns_topics_arns)
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
  count                     = var.error_rate_4XX_enabled ? 1 : 0
  alarm_name                = "ALB | 4XX Error Rate (>${var.error_rate_4XX_threshold}%) | ${data.aws_lb_target_group.target_group.name}"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 12
  datapoints_to_alarm       = 8
  threshold                 = var.error_rate_4XX_threshold
  alarm_description         = "4XX Error rate monitoring for ${data.aws_lb_target_group.target_group.name}"
  alarm_actions             = concat(var.error_rate_4XX_sns_topics_arns, var.global_sns_topics_arns)
  ok_actions                = concat(var.error_rate_4XX_sns_topics_arns, var.global_sns_topics_arns)
  insufficient_data_actions = concat(var.error_rate_4XX_sns_topics_arns, var.global_sns_topics_arns)
  treat_missing_data        = "breaching"

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
      period      = 300
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
      period      = 300
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
  count                     = var.error_rate_5XX_enabled ? 1 : 0
  alarm_name                = "ALB | 5XX Error Rate (>${var.error_rate_5XX_threshold}%) | ${data.aws_lb_target_group.target_group.name}"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 12
  datapoints_to_alarm       = 8
  threshold                 = var.error_rate_5XX_threshold
  alarm_description         = "5XX Error rate monitoring for ${data.aws_lb_target_group.target_group.name}"
  alarm_actions             = concat(var.error_rate_5XX_sns_topics_arns, var.global_sns_topics_arns)
  ok_actions                = concat(var.error_rate_5XX_sns_topics_arns, var.global_sns_topics_arns)
  insufficient_data_actions = concat(var.error_rate_5XX_sns_topics_arns, var.global_sns_topics_arns)
  treat_missing_data        = "breaching"

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
      period      = 300
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
      period      = 300
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        TargetGroup  = data.aws_lb_target_group.target_group.arn_suffix
        LoadBalancer = split("loadbalancer/", tolist(data.aws_lb_target_group.target_group.load_balancer_arns)[0])[1]
      }
    }
  }
}

