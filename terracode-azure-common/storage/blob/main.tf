# Conditional logic to determine storage account name
locals {
  final_storage_account_name = var.use_existing_storage_account ? var.existing_storage_account_name : var.storage_account_name
}

# Data source for existing storage account
data "azurerm_storage_account" "existing" {
  count               = var.use_existing_storage_account ? 1 : 0
  name                = var.existing_storage_account_name
  resource_group_name = var.existing_resource_group_name
}

# Resource group creation (if not using existing storage account)
resource "azurerm_resource_group" "rg" {
  count    = var.use_existing_storage_account ? 0 : 1
  name     = var.resource_group_name
  location = var.location
}

# Storage account creation (if not using existing)
resource "azurerm_storage_account" "storage" {
  count                    = var.use_existing_storage_account ? 0 : 1
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg[0].name
  location                 = azurerm_resource_group.rg[0].location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Determine container name
locals {
  final_container_name = var.use_existing_container ? var.existing_container_name : var.container_name
}

# Storage container creation (if not using existing)
resource "azurerm_storage_container" "container" {
  count                 = var.use_existing_container ? 0 : 1
  name                  = var.container_name
  storage_account_name  = local.final_storage_account_name
  container_access_type = var.container_access_type
}

# Storage blob creation
resource "azurerm_storage_blob" "blob" {
  name                   = var.blob_name
  storage_account_name   = local.final_storage_account_name
  storage_container_name = local.final_container_name
  type                   = var.blob_type
  source                 = var.source
  content_type           = var.content_type
  metadata               = var.metadata
}
