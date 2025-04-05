variable "delete_os_disk_on_termination" {
    description = "delete os disk on vm destroy"
    type = bool
    default = false
}

variable "subscription_id" {
    type = string
}

variable "tenant_id" {
    type = string
}

variable "admin_username" {
    type = string
}

variable "admin_password" {
    type = string
}