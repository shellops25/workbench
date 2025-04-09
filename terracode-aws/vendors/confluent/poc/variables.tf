variable "confluent_api_key" {
  description = "Confluent Cloud API Key"
  type        = string
}

variable "confluent_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "environment_name" {
  description = "Confluent Environment Name"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region for PrivateLink"
  type        = string
  default     = "us-east-1"
}
