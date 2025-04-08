variable "bucket_name" {
  description = "Base name of the S3 bucket"
  type        = string
}

variable "source_vpce_id" {
  description = "VPC endpoint ID to restrict S3 access"
  type        = string
  default     = null
}

