variable "vm_name" {
  default = "FOO"
}

variable "resource_group_name" {
  default = "rg_terraform_common"
}

variable "location" {
  default = "westus2"
}

variable "vm_size" {
  default = "Standard_B2s"
}

variable "subscription_id" {
  default     = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable "tenant_id" {
  default     = "XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXX"
}

variable "admin_username" {
  default = "foo"
}

variable "admin_password" {
  default = "foo"
}

variable "image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

variable "tags" {
  type        = map(string)
  default = {
    ApplicationOwner     = "Ops"
    BusinessUnit         = "Tech"
    Environment          = "DEV"
    InstantiationDate    = formatdate("YYYY-MM-DD", timestamp())
    LifeCycleStage       = "In production"
    Location             = "Azure"
    Source               = "Terraform"
    SupportTeam          = "Ops"
  }
}

variable "account_tier" {
  default     = "Standard"
}

variable "storage_account_type" {
  default     = "Premium_LRS"
}

variable "os_disk_name" {}

variable "is_windows_image" {
  default = true
}

variable "vm_os_id" {
  default     = ""
}

variable "vm_os_simple" {
  default = ""
}

variable "data_disk" {
  default = false
}

variable "data_disk_size_gb" {
  default = ""
}

variable "data_sa_type" {
  default = "Standard_LRS"
}

variable "storage_replication_type" {
  default = "LRS"
}

variable "delete_os_disk_on_termination" {
  default = false
}

# Boot diagnostics
variable "boot_diagnostics" {
  default     = true
}

variable "boot_diagnostics_sa_type" {
  default     = "Standard_LRS"
}

# Networking
variable "accelerated_networking_enabled" {
  default = true
}

variable "enable_accelerated_networking" {
  default = true
}

variable "subnet_id" {}

variable "network_interface_id" {}

variable "vnet_name" {
  default     = ""
}

variable "vnet_rg" {
  default     = ""
}

variable "nsg_id" {
  default = ""
}

variable "subnet_name" {
  default     = ""
}

variable "private_ip_address" {
  default = ""
}

variable "private_ip_address_allocation" {
  default = "Static"
}

variable "public_ip_dns" {
  default = [""]
}

variable "remote_port" {
  default     = ""
}
