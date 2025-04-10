variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the data S3 bucket"
  default     = "dev-mulesoft-poc"
}

variable "logging_bucket_name" {
  description = "Name of the logging S3 bucket"
  default     = "dev-mulesoft-poc-logs"
}

variable "iam_role_name" {
  description = "Name of the IAM role for MuleSoft"
  default     = "ch2-s3-servicerole-test"
}

variable "mulesoft_service_role_arn" {
  description = "ARN of the MuleSoft service role (CH2 role)"
  type        = string
}

variable "external_id" {
  description = "External ID provided by MuleSoft"
  type        = string
}

variable "mulesoft_source_cidrs" {
  description = "List of CIDR blocks from MuleSoft CH2.0 Private Space"
  type        = list(string)
}

variable "ec2_instance_role_arn" {
  description = "IAM role ARN of the EC2 instance needing access"
  type        = string
}
