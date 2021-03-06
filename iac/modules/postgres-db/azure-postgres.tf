locals {
  cloud_provider = "azure"
}

resource "azurerm_postgresql_server" "psqlserver" {
  count  = contains(var.selected_providers, local.cloud_provider) ? 1 : 0

  name                              = join("-", [var.prefix, "srv", var.environment])
  location                          = var.location
  resource_group_name               = var.resource_group_name

  sku_name                          = var.psql_sku_name
  version                           = var.psql_version
  storage_mb                        = var.psql_storage_mb
  backup_retention_days             = var.psql_storage_backup_rd
  geo_redundant_backup_enabled      = var.psql_storage_backup_geor
  ssl_enforcement_enabled           = var.psql_ssl_enforcement
  administrator_login               = join("", [var.prefix, replace(regex("(.*)@.*", var.admin_user)[0],"-","")])
  administrator_login_password      = var.core_db_pass

  # general default
  auto_grow_enabled                 = true
  infrastructure_encryption_enabled = false
  create_mode                       = "Default"  
}

resource "azurerm_postgresql_virtual_network_rule" "psql_vnet_rule" {
  count  = contains(var.selected_providers, local.cloud_provider) ? 1 : 0

  name                                 = join("-", ["vnet", "rule", var.environment])
  resource_group_name                  = var.resource_group_name
  server_name                          = one(azurerm_postgresql_server.psqlserver[*].name)
  subnet_id                            = var.subnet_id
  ignore_missing_vnet_service_endpoint = true
}

resource "azurerm_postgresql_firewall_rule" "fw0" {
  name                = join("-", [var.prefix, "fw", "0", var.environment])
  resource_group_name = var.resource_group_name
  server_name         = one(azurerm_postgresql_server.psqlserver[*].name)
  start_ip_address    = replace(var.allowed_external_access_addresses[0], "/\\/.*/", "")
  end_ip_address      = replace(var.allowed_external_access_addresses[0], "/\\/.*/", "")
}

resource "azurerm_postgresql_database" "psqldb" {
  count  = contains(var.selected_providers, local.cloud_provider) ? 1 : 0

  name                = "backstage_plugin_catalog" #join("-", [var.prefix, "db", var.environment])
  resource_group_name = var.resource_group_name
  server_name         = one(azurerm_postgresql_server.psqlserver[*].name)
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_private_endpoint" "db-vnet-endpoint" {
  name                = join("-", [one(azurerm_postgresql_database.psqldb[*].name), "vnet-endpoint"])
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = join("-", [one(azurerm_postgresql_database.psqldb[*].name), "privateserviceconnection"])
    private_connection_resource_id = one(azurerm_postgresql_server.psqlserver[*].id)
    subresource_names              = [ "postgresqlServer" ]
    is_manual_connection           = false
  }
}