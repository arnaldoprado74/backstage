locals {
  cloud_provider = "azure"
}

resource "azurerm_user_assigned_identity" "uai" {
  count  = contains(var.selected_providers, local.cloud_provider) ? 1 : 0

  name                  = join("-", [var.prefix, "uai", var.environment])
  location              = var.location
  resource_group_name   = var.resource_group_name
}

resource "azurerm_container_registry" "acr" {
  count  = contains(var.selected_providers, local.cloud_provider) ? 1 : 0

  name                              = join("", [var.prefix, "acr", var.environment])
  location                          = var.location
  resource_group_name               = var.resource_group_name
  sku                               = "Standard"

  identity {
    type = "UserAssigned"
    identity_ids = [
      one(azurerm_user_assigned_identity.uai[*].id)
    ]
  }

#   encryption {
#     enabled            = true
#     key_vault_key_id   = data.azurerm_key_vault_key.example.id
#     identity_client_id = azurerm_user_assigned_identity.example.client_id
#   }

}