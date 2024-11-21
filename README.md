![image info](logo.jpeg)

# Terraform-aws-target-group-monitor

Terraform-aws-tg-monitor is a Terraform module for setting up a notification system about cloudwatch metrics.

## Installation

To use this module, you need to have Terraform installed. You can find installation instructions on the Terraform website.

## Usage

The module will create a notification system to alert when health check is failed.
Use this module multiple times to create repositories with different configurations.

Include this repository as a module in your existing terraform code:

```python

################################################################################
# AWS TG-MONITOR
################################################################################

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
  health_count_threshold= 1
  tags = {
    Environment = "dev"
  }
  load_balancer_name = data.aws_lb.load_balancer.name
  aws_sns_topic_arn  = aws_sns_topic.sns_topic.arn
}

```

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                   | Version   |
| ------------------------------------------------------ | --------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 4.67.0 |

## Providers

| Name                                             | Version   |
| ------------------------------------------------ | --------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 4.67.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                            | Type     |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_cloudwatch_metric_alarm.health_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |

## Inputs

| Name                                                                                                | Description                    | Type          | Default | Required |
| --------------------------------------------------------------------------------------------------- | ------------------------------ | ------------- | ------- | :------: |
| <a name="input_aws_sns_topic_arn"></a> [aws_sns_topic_arn](#input_aws_sns_topic_arn)                | ARN of the SNS topic           | `string`      | n/a     |   yes    |
| <a name="input_load_balancer_name"></a> [load_balancer_name](#input_load_balancer_name)             | Name of the load balancer      | `string`      | n/a     |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                       | Tags to apply to the resources | `map(string)` | `{}`    |    no    |
| <a name="input_target_group_name"></a> [target_group_name](#input_target_group_name)                | Name of the target group       | `string`      | n/a     |   yes    |
| <a name="input_health_count_threshold"></a> [health_count_threshold](#input_health_count_threshold) | Target group threshold         | `number`      | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
