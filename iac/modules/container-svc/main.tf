locals {
  cloud_provider = "azure"
  app_name       = join("-", [var.prefix, "webapp", var.environment])

  envariables    = merge( 
    {
      "WEBSITE_HEALTHCHECK_MAXPINGFAILURES" = "10"
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = true
      "WEBSITES_PORT"                       = var.service_port
      "DOCKER_REGISTRY_SERVER_URL"          = var.external_registry_url
      "DOCKER_REGISTRY_SERVER_USERNAME"     = var.external_registry_username
      "DOCKER_REGISTRY_SERVER_PASSWORD"     = var.external_registry_password
      "AZURE_WEBAPP_NAME"                   = local.app_name
    },
    var.service_env
  )
}

# data "azurerm_key_vault" "kv" {
#   name                = join("", ["kv", var.company_name, "default"])
#   resource_group_name = "Default"
# }

# data "azurerm_key_vault_secret" "registry-admin-secret" {
#   name         = "registry-admin-secret"
#   key_vault_id = data.azurerm_key_vault.kv.id
# }

resource "azurerm_app_service_plan" "webapp_plan" {
  count  = contains(var.selected_providers, local.cloud_provider) ? 1 : 0

  name                = join("-", ["webapp", "plan", var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true

  sku {
    tier     = "PremiumV2"
    size     = "P1v2"
  }
}

resource "azurerm_app_service" "webapp_container" {
  count  = contains(var.selected_providers, local.cloud_provider) ? 1 : 0
  
  name                    = local.app_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  app_service_plan_id     = one(azurerm_app_service_plan.webapp_plan[*].id)
  https_only              = false
  client_affinity_enabled = false

  site_config {
    always_on         = "true"
    linux_fx_version  = join("", ["DOCKER|", var.image_path]) #define the images to use for you application
    health_check_path = var.health_check_path # healthD check required in order that internal app service plan loadbalancer do not loadbalance on instance down
    ip_restriction {
      ip_address = var.allowed_external_access_addresses[0]
      name = "ANP"
      priority =  300
    }
    ip_restriction {
     virtual_network_subnet_id = var.inbound_subnet_id
     name = "Inbound VNET"
     priority =  65000
    }
  }

  app_settings = local.envariables 
}

resource "azurerm_app_service_virtual_network_swift_connection" "swift_app_service" {   # VNET association to access private resources
  app_service_id = one(azurerm_app_service.webapp_container[*].id)
  subnet_id      = var.swift_subnet_id
}

resource "azurerm_postgresql_firewall_rule" "fw_db" {
  count = length(var.db_server_name != null ? one(azurerm_app_service.webapp_container[*].possible_outbound_ip_address_list) : [])

  name                = join("-", [var.prefix, replace(one(azurerm_app_service.webapp_container[*].possible_outbound_ip_address_list[count.index]),".","")])
  resource_group_name = var.resource_group_name
  server_name         = var.db_server_name
  start_ip_address    = one(azurerm_app_service.webapp_container[*].possible_outbound_ip_address_list[count.index])
  end_ip_address      = one(azurerm_app_service.webapp_container[*].possible_outbound_ip_address_list[count.index])

  depends_on = [
    azurerm_app_service.webapp_container
  ]
}