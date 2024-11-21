provider "aws" {
  region = "eu-west-1"
}

resource "aws_sns_topic" "sns_topic" {
  name         = "sns"
  display_name = "sns"
}

resource "aws_sns_topic_subscription" "sns_subscription" {
  confirmation_timeout_in_minutes = 1
  endpoint_auto_confirms          = false
  topic_arn                       = aws_sns_topic.sns_topic.arn
  protocol                        = "https"
  endpoint                        = "https://api.sns.com/v1/xxx"
  depends_on                      = [aws_sns_topic.sns_topic]
}

data "aws_lb_target_group" "load_balancer_tg" {
  arn  = var.lb_tg_arn
  name = "my-load-balancer-tg"
}
data "aws_lb" "load_balancer" {
  arn  = var.lb_arn
  name = "my-load-balancer"
}

module "target_group_alerts" {
  source = "delivops/tg-alerts/aws"
  #version            = "0.0.1"

  target_group_name      = data.aws_lb_target_group.load_balancer_tg.name
  health_count_threshold = 1
  tags = {
    Environment = "dev"
  }
  load_balancer_name = data.aws_lb.load_balancer.name
  aws_sns_topic_arn  = aws_sns_topic.sns_topic.arn
}
