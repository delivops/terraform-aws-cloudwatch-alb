![image info](logo.jpeg)

# Terraform-aws-target-group-monitor

Terraform-aws-tg-monitor is a Terraform module for setting up a notification system about cloudwatch metrics.

## Installation

To use this module, you need to have Terraform installed. You can find installation instructions on the Terraform website.

## Information

The tags that you use for your module should be unique, and fit exactly to one tg.

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
| <a name="input_aws_sns_topics_arns"></a> [aws\_sns\_topics\_arns](#input\_aws\_sns\_topics\_arns) | ARN of the SNS topic | `list(string)` | n/a | yes |
| <a name="input_error_rate_4XX_threshold"></a> [error\_rate\_4XX\_threshold](#input\_error\_rate\_4XX\_threshold) | Threshold for 4XX error rate | `number` | `8` | no |
| <a name="input_error_rate_5XX_threshold"></a> [error\_rate\_5XX\_threshold](#input\_error\_rate\_5XX\_threshold) | Threshold for 5XX error rate | `number` | `8` | no |
| <a name="input_minimum_health_hosts"></a> [minimum\_health\_hosts](#input\_minimum\_health\_hosts) | Minimum number of healthy hosts | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the resources | `map(string)` | `{}` | no |
| <a name="input_unique_tags"></a> [unique\_tags](#input\_unique\_tags) | Unique tags that helps to find the resources | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
