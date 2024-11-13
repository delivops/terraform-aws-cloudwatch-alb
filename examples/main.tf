provider "aws" {
  region = "eu-west-1"
}

resource "aws_sns_topic" "opsgenie_topic" {
  name         = "opsgenie"
  display_name = "opsgenie"
}

resource "aws_sns_topic_subscription" "opsgenie_subscription" {
  confirmation_timeout_in_minutes = 1
  endpoint_auto_confirms          = false
  topic_arn                       = aws_sns_topic.opsgenie_topic.arn
  protocol                        = "https"
  endpoint                        = "https://api.opsgenie.com/v1/xxx"
  depends_on                      = [aws_sns_topic.opsgenie_topic]
}

module "target_group" {
  source = "../"

  target_group_name      = "targetgroup/k8s-vops-vopsapia-667ca6b156/xxx"
  target_group_threshold = 1
  tags = {
    Environment = "dev"
  }
  load_balancer_name = "app/k8s-vops-7a822ebbb8/xxx"
  aws_sns_topic_arn  = aws_sns_topic.opsgenie_topic.arn
}




