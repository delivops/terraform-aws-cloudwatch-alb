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

module "target_group" {
  source = "delivops/tg-alerts/aws"
  #version            = "0.0.1"

  target_group_name      = "targetgroup/k8s-vops-vopsapia-667ca6b156/xxx"
  target_group_threshold = 1
  tags = {
    Environment = "dev"
  }
  load_balancer_name = "app/k8s-vops-7a822ebbb8/xxx"
  aws_sns_topic_arn  = aws_sns_topic.sns_topic.arn
}
