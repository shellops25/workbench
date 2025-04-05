variable "vm_name"  {
  description = "Name of the virtual machine"
  type        = string
  default     = "my-vm"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "my-resource-group"}
}

variable "location " {
  description = "Azure region for the resources"
  type        = string
  default     = "westus2"
}

variable "vm_size"  {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
}   

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "your-subscription-id"
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
  default     = "your-tenant-id"      
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
  default     = "P@ssw0rd1234!"
}

variable = "image_reference" {
  description = "Image reference for the VM"
  type        = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {
    environment = "dev"
    project     = "terraform-azure"
  }
}

variable "account_tier" {
    description = "Storage account tier"
    type        = string
    default     = "Standard"
}

variable "storage_account_type" {
    description = "Storage account replication type"
    type        = string
    default     = "LRS"
}

variable "os_disk_name" {
    description = "Name of the OS disk"
    type        = string
    default     = "osdisk"
}

variable "is_windows_image" {
    description = "Is the image a Windows image?"
    type        = bool
    default     = false
}

variable "delete_os_disk_on_termnination" {
    description = "Delete the OS disk on VM termination"
    type        = bool
    default     = true
}

variable "secure_boot_enabled" {
    description = "Enable secure boot for the VM"
    type        = bool
    default     = false
}

variable "vtpm_enabled" {
    description = "Enable vTPM for the VM"
    type        = bool
    default     = false
}

variable "vm_os_simple" {
    description = "OS type of the VM"
    type        = string
    default     = "Linux"
}

variable "data_disk"   {
    description = "Data disk configuration"
    type        = list(object({
        name     = string
        size_gb  = number
        caching  = string
        managed_disk_type = string
    }))
    default     = []
}
variable  "data_sa_type" {
    description = "Storage account type for data disks"
    type        = string
    default     = "Standard_LRS"
}

variable "storage_replication_type" {
    description = "Storage replication type for data disks"
    type        = string
    default     = "LRS"
}

variable "boot_diagnostics" {
    description = "Enable boot diagnostics"
    type        = bool
    default     = false
}

variable "accelerated_networking_enabled" {
    description = "Enable accelerated networking"
    type        = bool
    default     = false
}

variable "subnet_id" {
    description = "Subnet ID for the VM"
    type        = string
    default     = ""
}
variable "network_interface_ids" {
    description = "Network interface IDs for the VM"
    type        = list(string)
    default     = []
}
variable "nsg_id" { 
    description = "Network security group ID for the VM"
    type        = string
    default     = ""
}

variable "private_ip_address" {
    description = "Private IP address for the VM"
    type        = string
    default     = ""
}

variable "private_ip_address_allocation" {
    description = "Private IP address allocation method"
    type        = string
    default     = "Static"
}
variable "public_ip_address" {
    description = "Public IP address for the VM"
    type        = string
    default     = ""
}

variable "remote_port"  {
    description = "Remote port for the VM"
    type        = number
    default     = 22
}