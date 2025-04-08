output "storage_account_name" {
  description = "The name of the storage account used."
  value       = local.final_storage_account_name
}

output "container_name" {
  description = "The name of the storage container used."
  value       = local.final_container_name
}

output "blob_url" {
  description = "The URL of the created blob."
  value       = azurerm_storage_blob.blob.url
}
