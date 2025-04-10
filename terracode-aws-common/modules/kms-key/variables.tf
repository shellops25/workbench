variable "alias" {
  description = "The alias name for the KMS key (without 'alias/' prefix)"
  type        = string
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = "Managed by Terraform"
}

variable "key_usage" {
  description = "Key usage for the KMS key"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "deletion_window_in_days" {
  description = "Number of days before the key is deleted after destruction"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to assign to the key"
  type        = map(string)
  default     = {}
}
