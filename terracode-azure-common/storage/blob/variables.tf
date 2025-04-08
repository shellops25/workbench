variable "use_existing_storage_account" {
  description = "Set to true to use an existing storage account; false to create a new one."
  type        = bool
  default     = false
}

variable "existing_storage_account_name" {
  description = "The name of the existing storage account."
  type        = string
  default     = ""
}

variable "existing_resource_group_name" {
  description = "The name of the resource group containing the existing storage account."
  type        = string
  default     = ""
}

variable "storage_account_name" {
  description = "The name of the storage account to create."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = ""
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = ""
}

variable "use_existing_container" {
  description = "Set to true to use an existing container; false to create a new one."
  type        = bool
  default     = false
}

variable "existing_container_name" {
  description = "The name of the existing storage container."
  type        = string
  default     = ""
}

variable "container_name" {
  description = "The name of the storage container to create."
  type        = string
  default     = ""
}

variable "container_access_type" {
  description = "The access level for the container."
  type        = string
  default     = "private"
}

variable "blob_name" {
  description = "The name of the blob."
  type        = string
}

variable "blob_type" {
  description = "The type of the blob to be created."
  type        = string
  default     = "Block"
}

variable "source" {
  description = "The path to the source of the blob."
  type        = string
}

variable "content_type" {
  description = "The content type of the blob."
  type        = string
  default     = null
}

variable "metadata" {
  description = "A map of custom metadata to associate with the blob."
  type        = map(string)
  default     = {}
}
