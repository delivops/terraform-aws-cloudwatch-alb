provider "aws" {
  region = "eu-west-1"
}

resource "aws_sns_topic" "sns_topic" {
  name         = "sns"
  display_name = "sns"
}

resource "aws_sns_topic" "sns_second_topic" {
  name         = "sns2"
  display_name = "sns2"
}

module "target_group_alerts" {
  source = "delivops/cloudwatch-alb/aws"
  #version            = "0.0.10"

  unique_tags = {
    "ingress.k8s.aws/resource" = "teleport/teleport"
    Environment                = "prod"
  }
  tags = {
    Environment = "dev"
  }
  minimum_health_hosts                 = 1
  global_sns_topics_arns               = [aws_sns_topic.sns_topic.arn]
  minimum_health_hosts_sns_topics_arns = [aws_sns_topic.sns_second_topic.arn]
  error_rate_4XX_threshold             = 8.0
  error_rate_5XX_threshold             = 8.0
}
