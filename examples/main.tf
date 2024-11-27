provider "aws" {
  region = "eu-west-1"
}

resource "aws_sns_topic" "sns_topic" {
  name         = "sns"
  display_name = "sns"
}

module "target_group_alerts" {
  source = "delivops/cloudwatch-tg/aws"
  #version            = "0.0.2"

  unique_tags = {
    "ingress.k8s.aws/resource" = "teleport/teleport"
    Environment                = "prod"
  }
  tags = {
    Environment = "dev"
  }
  minimum_health_hosts     = 1
  aws_sns_topic_arn        = [var.aws_sns_topic_arn]
  error_rate_4XX_threshold = 8.0
  error_rate_5XX_threshold = 8.0
}
