variable "minimum_health_hosts" {
  description = "Minimum number of healthy hosts"
  type        = number
  default     = 1
}
variable "minimum_health_hosts_enabled" {
  description = "Enable minimum number of healthy hosts"
  type        = bool
  default     = true
  
}
variable "minimum_health_hosts_sns_topics_arns" {
  description = "ARN of the SNS topic"
  type        = list(string)
  default = [ ]
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
variable "global_sns_topics_arns" {
  description = "global ARN of the SNS topic"
  type        = list(string)
  default = [ ]
}
variable "error_rate_4XX_sns_topics_arns" {
  description = "ARN of the SNS topic"
  type        = list(string)
  default = [ ]
  
}
variable "error_rate_4XX_threshold" {
  description = "Threshold for 4XX error rate"
  type        = number
  default     = 8.0
  
}
variable "error_rate_4XX_enabled" {
  description = "Enable 4XX error rate"
  type        = bool
  default     = true
  
}
variable "error_rate_5XX_threshold" {
  description = "Threshold for 5XX error rate"
  type        = number
  default     = 8.0
}
variable "error_rate_5XX_enabled" {
  description = "Enable 5XX error rate"
  type        = bool
  default     = true
}
variable "error_rate_5XX_sns_topics_arns" {
  description = "ARN of the SNS topic"
  type        = list(string)
  default = [ ]
}

