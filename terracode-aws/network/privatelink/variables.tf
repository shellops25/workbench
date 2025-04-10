variable "vpc_id" {
  description = "The ID of the VPC in which to create the PrivateLink endpoint"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs in separate availability zones for the VPC endpoint"
  type        = list(string)
}

variable "confluent_service_name" {
  description = "The service name provided by Confluent for the PrivateLink endpoint"
  type        = string
}
