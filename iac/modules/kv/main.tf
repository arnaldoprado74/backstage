resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.company_name}-${var.environment}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id

  sku_name = "standard"

   network_acls {
     default_action             = "Deny" 
     bypass                     = "AzureServices"
     ip_rules                   = var.allowed_external_access_addresses
#     virtual_network_subnet_ids = [data.terraform_remote_state.shared_base_vpn.outputs.k8s_subnet_id]
   }
}

resource "azurerm_key_vault_access_policy" "api_access_policy_admin" {

   key_vault_id = azurerm_key_vault.kv.id

   tenant_id = var.tenant_id
   object_id = var.tenant_user_object_id

    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
    ]

    storage_permissions = [
      "get",
    ]

    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]
}

# Secrets
resource "azurerm_key_vault_secret" "secrets" {
  for_each  = var.keyvault_secrets
    name                = each.key
    value               = each.value
    key_vault_id        = azurerm_key_vault.kv.id
}
