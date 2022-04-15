resource "azurerm_storage_account" "stg" {
  name                     = join("", [replace(var.company_name, "/-/", ""), var.prefix, var.environment])
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.account_replication
  allow_blob_public_access = var.allow_blob_public_access
}