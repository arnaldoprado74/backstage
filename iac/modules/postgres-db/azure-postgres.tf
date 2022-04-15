locals {
  cloud_provider = "azure"
}

resource "azurerm_postgresql_server" "psqlserver" {
  count  = contains(var.selected_providers, local.cloud_provider, "#") == "#" ? 0 : 1

  name                              = join("-", [var.prefix, var.environment])
  location                          = var.location
  resource_group_name               = var.resource_group_name

  sku_name                          = var.psql_sku_name
  storage_mb                        = var.psql_storage_mb
  backup_retention_days             = var.psql_storage_backup_rd
  geo_redundant_backup_enabled      = var.psql_storage_backup_geor
  auto_grow_enabled                 = true
  infrastructure_encryption_enabled = false
  
  administrator_login               = replace(regex("(.*)@.*", var.admin_user)[0],"-","")
  administrator_login_password      = var.core_db_pass
  version                           = var.psql_version
  ssl_enforcement_enabled           = var.psql_ssl_enforcement
  create_mode                       = "Default"
}

resource "azurerm_postgresql_virtual_network_rule" "psql_vnet_rule" {
  count  = contains(var.selected_providers, local.cloud_provider, "#") == "#" ? 0 : 1

  name                                 = join("-", ["vnet", "rule", var.environment])
  resource_group_name                  = var.resource_group_name
  server_name                          = azurerm_postgresql_server.psqlserver.name
  subnet_id                            = var.subnet_id
  ignore_missing_vnet_service_endpoint = true
}