terraform {
    required_providers  {
      azurerm = {
          source = "azurerm"
          version = "4.20.0"
      }
    }
}


resource "azurerm_network_interface" "nic" {
    name = "nic_${var.vm_name}"
    location = var.location
    resource_group_name = var.resource_group_name
    accelerated_networking_enabled = var.accelerated_networking_enabled
    ip_configuration {
        name = "ipconfig_${var.vm_name}"
        subnet_id = var.subnet_id
        private_ip_address = var.private_ip_address
        private_ip_address_allocation = var.private_ip_address_allocation
    }
    tags = var.tags
}

resource "azurerm_windows_virtual_machine" "vm-windows" {
    name = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
    location = var.location
    network_interface_ids = [azurerm_network_interface.nic.id]
    resource_group_name = var.resource_group_name
    secure_boot_enabled = var.secure_boot_enabled
    size   = var.vm_size
    vtpm_enabled = var.vtpm_enabled
    provision_vm_agent = true
    enable_automatic_updates = true
    vm_agent_platform_updates_enabled = true

    os_disk {
        name = var.os_disk_name != null ? var.os_disk_name : "${var.vm_name}-osdisk"
        storage_account_type = var.storage_account_type

    }

    source_image_reference {
        publisher = var.image_publisher
        offer = var.image_offer
        sku = var.image_sku
        version = var.image_version
    }

    winrm_listeners {
        protocol = "http"
        #certificate_url = var.certificate_url
        port = var.winrm_port
    }
    boot_diagnostics {
        storage_account_uri = null
        enabled = true
        managed = true
    }
    tags = var.tags
}

data "azurerm_managed_disk" "os_disk_id" {
    name = "${var.vm_name}-osdisk"
    resource_group_name = var.resource_group_name
    depends_on = [ azurerm_windows_virtual_machine.vm-windows ]
}