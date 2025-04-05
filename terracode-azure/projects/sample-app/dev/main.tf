provider "azurem" {
  subscription_id   = "var.subscription_id"
  tenant_id         = "var.tenant_id"
  features {
    virtual_machine {
        delete_os_disk_on_deletion = var.delete_os_disk_on_deletion
    }
  }
  
locals {
    location = "East US"        
    resource_group_name = "rg-${var.environment}-${var.project_name}"
    vm_size =  "Standard_D4ds_v5"
    vm_os_publisher = "MicosoftWindowsDesktop"
    vm_os_sku = "win11-24h2-ent"
    vm_os_offer = "Windows-11"
    vtpm_enabled = true
    secure_boot_enabled = true
    // az network vnet subnet show --name name --vnet-name vnet-name --resource-group rg-name --query id -o tsv
    subnet_id = "/subscriptions/xxxx/resourceGroups/rg-name/providers/Microsoft.Network/virtualNetworks/vnet-name/subnets/subnet-name"
    admin_username = var.admin_password
    admin_password = var.admin_password
    tags = {
        environment = "prod"
        project_name = v"sample-project"
        owner = "shellops25"
    }
}

module "dev_vm_MYNEWHOST" {
  source = "git::ssh://git@github.com/shellops25/workbench/terraform-azure-common/modules/vm-general?ref=v1.0.2"
  vm_name = "NEWVM01"
  location = local.location
  resource_group_name = local.resource_group_name
  subnet_id = local.subnet_id
  network_interface_id = null # does not need to be passed
  os_disk_name = null # os_disk_name is omitted, standard name will be used via module
  private_ip_address = "192.168.0.1"
  admin_username = local.admin_username
  admin_password = local.admin_password
    image_reference = {
        publisher = local.vm_os_publisher
        offer = local.vm_os_offer
        sku = local.vm_os_sku
        version = "latest"
    }
  tags = local.tags
}
