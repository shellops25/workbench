# Azure Storage Module

This Terraform module allows for flexible creation and management of Azure Storage resources, including storage accounts, containers, and blobs. It supports various scenarios:

- Using existing storage accounts and containers to create new blobs.
- Creating new containers within existing storage accounts and adding blobs.
- Creating new storage accounts, containers, and blobs.

## Usage

### Create a Blob in an Existing Storage Account and Container

```hcl
module "azure_blob" {
  source                      = "../terracode-azure-common/storage/blob"
  use_existing_storage_account = true
  existing_storage_account_name = "existingstorageacct"
  existing_resource_group_name = "existing-rg"
  use_existing_container       = true
  existing_container_name      = "existing-container"
  blob_name                    = "new-blob"
# source                 = "/path/to/file.txt"
# source_uri             = "https://existingstorageaccount.blob.core.windows.net/container/existingfile.txt"
# source_content         = "This is the content of the blob."


}

### Create a New Container in an Existing Storage Account and Add a Blob

module "azure_blob" {
  source                      = "../terracode-azure-common/storage/blob"
  use_existing_storage_account = true
  existing_storage_account_name = "existingstorageacct"
  use_existing_container       = false
  container_name               = "existing-container"
  blob_name                    = "new-blob"
}
```
