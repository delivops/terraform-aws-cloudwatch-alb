variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}
variable "health_count_threshold" {
  description = "Health count threshold"
  type        = number

}
variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}
variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string

}
variable "aws_sns_topic_arn" {
  description = "ARN of the SNS topic"
  type        = string

}

