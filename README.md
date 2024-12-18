![image info](logo.jpeg)

# Terraform-aws-target-group-monitor

Terraform-aws-alb-monitor is a Terraform module for setting up a notification system about cloudwatch metrics.

## Installation

To use this module, you need to have Terraform installed. You can find installation instructions on the Terraform website.

## Information

The tags that you use for your module should be unique, and fit exactly to one alb.

## Usage

The module will create a notification system to alert when health check is failed.
Use this module multiple times to create repositories with different configurations.

Include this repository as a module in your existing terraform code:

```python

################################################################################
# AWS ALB-MONITOR
################################################################################

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
  all_alarms_sns_arns               = [aws_sns_topic.sns_topic.arn]
  minimum_health_hosts_sns_arns = [aws_sns_topic.sns_second_topic.arn]
  error_rate_4XX_threshold             = 8.0
  error_rate_5XX_threshold             = 8.0
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

| Name                                                                                                                                                    | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_metric_alarm.error_rate_4xx_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource    |
| [aws_cloudwatch_metric_alarm.error_rate_5xx_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource    |
| [aws_cloudwatch_metric_alarm.health_host_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm)    | resource    |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_target_group)                      | data source |

## Inputs

| Name                                                                                                                     | Description                                  | Type           | Default | Required |
| ------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_error_rate_4XX_enabled"></a> [error_rate_4XX_enabled](#input_error_rate_4XX_enabled)                      | Enable 4XX error rate                        | `bool`         | `true`  |    no    |
| <a name="input_error_rate_4XX_sns_arns"></a> [error_rate_4XX_sns_arns](#input_error_rate_4XX_sns_arns)                   | ARN of the SNS topic                         | `list(string)` | `[]`    |    no    |
| <a name="input_error_rate_4XX_threshold"></a> [error_rate_4XX_threshold](#input_error_rate_4XX_threshold)                | Threshold for 4XX error rate                 | `number`       | `8`     |    no    |
| <a name="input_error_rate_5XX_enabled"></a> [error_rate_5XX_enabled](#input_error_rate_5XX_enabled)                      | Enable 5XX error rate                        | `bool`         | `true`  |    no    |
| <a name="input_error_rate_5XX_sns_arns"></a> [error_rate_5XX_sns_arns](#input_error_rate_5XX_sns_arns)                   | ARN of the SNS topic                         | `list(string)` | `[]`    |    no    |
| <a name="input_error_rate_5XX_threshold"></a> [error_rate_5XX_threshold](#input_error_rate_5XX_threshold)                | Threshold for 5XX error rate                 | `number`       | `8`     |    no    |
| <a name="input_all_alarms_sns_arns"></a> [global_sns_arns](#input_global_sns_arns)                                       | global ARN of the SNS topic                  | `list(string)` | `[]`    |    no    |
| <a name="input_minimum_health_hosts"></a> [minimum_health_hosts](#input_minimum_health_hosts)                            | Minimum number of healthy hosts              | `number`       | `1`     |    no    |
| <a name="input_minimum_health_hosts_enabled"></a> [minimum_health_hosts_enabled](#input_minimum_health_hosts_enabled)    | Enable minimum number of healthy hosts       | `bool`         | `true`  |    no    |
| <a name="input_minimum_health_hosts_sns_arns"></a> [minimum_health_hosts_sns_arns](#input_minimum_health_hosts_sns_arns) | ARN of the SNS topic                         | `list(string)` | `[]`    |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                            | Tags to apply to the resources               | `map(string)`  | `{}`    |    no    |
| <a name="input_unique_tags"></a> [unique_tags](#input_unique_tags)                                                       | Unique tags that helps to find the resources | `map(string)`  | n/a     |   yes    |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
