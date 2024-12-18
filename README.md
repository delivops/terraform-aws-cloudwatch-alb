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
  global_sns_topics_arns               = [aws_sns_topic.sns_topic.arn]
  minimum_health_hosts_sns_topics_arns = [aws_sns_topic.sns_second_topic.arn]
  error_rate_4XX_threshold             = 8.0
  error_rate_5XX_threshold             = 8.0
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.67.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.error_rate_4xx_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.error_rate_5xx_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.health_host_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_target_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_error_rate_4XX_enabled"></a> [error\_rate\_4XX\_enabled](#input\_error\_rate\_4XX\_enabled) | Enable 4XX error rate | `bool` | `true` | no |
| <a name="input_error_rate_4XX_sns_topics_arns"></a> [error\_rate\_4XX\_sns\_topics\_arns](#input\_error\_rate\_4XX\_sns\_topics\_arns) | ARN of the SNS topic | `list(string)` | `[]` | no |
| <a name="input_error_rate_4XX_threshold"></a> [error\_rate\_4XX\_threshold](#input\_error\_rate\_4XX\_threshold) | Threshold for 4XX error rate | `number` | `8` | no |
| <a name="input_error_rate_5XX_enabled"></a> [error\_rate\_5XX\_enabled](#input\_error\_rate\_5XX\_enabled) | Enable 5XX error rate | `bool` | `true` | no |
| <a name="input_error_rate_5XX_sns_topics_arns"></a> [error\_rate\_5XX\_sns\_topics\_arns](#input\_error\_rate\_5XX\_sns\_topics\_arns) | ARN of the SNS topic | `list(string)` | `[]` | no |
| <a name="input_error_rate_5XX_threshold"></a> [error\_rate\_5XX\_threshold](#input\_error\_rate\_5XX\_threshold) | Threshold for 5XX error rate | `number` | `8` | no |
| <a name="input_global_sns_topics_arns"></a> [global\_sns\_topics\_arns](#input\_global\_sns\_topics\_arns) | global ARN of the SNS topic | `list(string)` | `[]` | no |
| <a name="input_minimum_health_hosts"></a> [minimum\_health\_hosts](#input\_minimum\_health\_hosts) | Minimum number of healthy hosts | `number` | `1` | no |
| <a name="input_minimum_health_hosts_enabled"></a> [minimum\_health\_hosts\_enabled](#input\_minimum\_health\_hosts\_enabled) | Enable minimum number of healthy hosts | `bool` | `true` | no |
| <a name="input_minimum_health_hosts_sns_topics_arns"></a> [minimum\_health\_hosts\_sns\_topics\_arns](#input\_minimum\_health\_hosts\_sns\_topics\_arns) | ARN of the SNS topic | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the resources | `map(string)` | `{}` | no |
| <a name="input_unique_tags"></a> [unique\_tags](#input\_unique\_tags) | Unique tags that helps to find the resources | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
