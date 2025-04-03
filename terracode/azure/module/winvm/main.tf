terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.20.0" 
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  features {
    virtual_machine {
      delete_os_disk_on_deletion          = var.delete_os_disk_on_termination
      detach_implicit_data_disk_on_deletion = false # Review this as needed
    }
  }
}

data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

data "azurerm_network_interface" "existing" {
  name                = var.network_interface_name
  resource_group_name = data.azurerm_resource_group.existing.name
}

resource "azurerm_windows_virtual_machine" "vm-windows" {
  name                = var.vm_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  location            = var.location
  network_interface_ids = [
    var.network_interface_id
  ]
  resource_group_name     = data.azurerm_resource_group.vm.name
  size                    = var.vm_size
  secure_boot_enabled     = var.secure_boot_enabled
  vtpm_enabled            = var.vtpm_enabled
  provision_vm_agent      = true
  enable_automatic_updates = true

  os_disk {
    name                 = "osdisk_${var.vm_hostname}${format("%02d", count.index + var.vm_number_start)}"
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
    create_option        = "FromImage"
  }

  source_image_reference {
    publisher = var.image_reference.publisher
    offer     = var.image_reference.offer
    sku       = var.image_reference.sku
    version   = var.image_reference.version
  }

  winrm_listener {
    protocol        = "Http"
    # certificate_url = "" 
  }

  boot_diagnostics {
    enabled             = var.boot_diagnostics
    storage_account_uri = azurerm_storage_account.vm_sa.primary_blob_endpoint
  }

  tags = var.tags
}
