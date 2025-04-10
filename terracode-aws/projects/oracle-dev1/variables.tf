
variable "vpc_id" {
  description = "VPC ID where the NLB and target will be placed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for NLB placement"
  type        = list(string)
}

variable "oracle_ip" {
  description = "IP address of the Oracle DNA server on-prem via DX"
  type        = string
  default     = "172.16.10.20"
}

variable "allowed_principal_arn" {
  description = "Confluent AWS account principal ARN"
  type        = string
}
