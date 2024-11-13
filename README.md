# Terraform-aws-target-group-monitor

Terraform-aws-tg-monitor is a Terraform module for setting up a notification system about cloudwatch metrics.

## Installation

To use this module, you need to have Terraform installed. You can find installation instructions on the Terraform website.

## Usage

The module will create a notification system to alert when health check is failed.
Use this module multiple times to create repositories with different configurations.

Include this repository as a module in your existing terraform code:

```python

provider "aws" {
  region = var.aws_region
  }

################################################################################
# AWS TG-MONITOR
################################################################################


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

```
