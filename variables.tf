variable "minimum_health_hosts" {
  description = "Minimum number of healthy hosts"
  type        = number
  default     = 1
}
variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}
variable "unique_tags" {
  description = "Unique tags that helps to find the resources"
  type        = map(string)
}
variable "aws_sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = list(string)
}
variable "error_rate_4XX_threshold" {
  description = "Threshold for 4XX error rate"
  type        = number
  default     = 8.0
  
}
variable "error_rate_5XX_threshold" {
  description = "Threshold for 5XX error rate"
  type        = number
  default     = 8.0
}

