locals {
  cloud_provider = "azure"
  app_name       = join("-", [var.prefix, "webapp", var.environment])

  envariables    = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = true
    "WEBSITES_PORT"                       = 8080
    # "DOCKER_REGISTRY_SERVER_URL"          = data.azurerm_container_registry.acr.login_server
    # "DOCKER_REGISTRY_SERVER_USERNAME"     = data.azurerm_container_registry.acr.admin_username
    # "DOCKER_REGISTRY_SERVER_PASSWORD"     = data.azurerm_container_registry.acr.admin_password
    "DOCKER_REGISTRY_SERVER_URL"          = "https://ghcr.io"
    "DOCKER_REGISTRY_SERVER_USERNAME"     = "arnaldo.prado74"
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = "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"
    "AZURE_WEBAPP_NAME"                   = local.app_name
  }
}

data "azurerm_container_registry" "acr" {
  name                = join("", [var.prefix, "acr", var.environment])
  resource_group_name = var.resource_group_name
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
  name                    = local.app_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  app_service_plan_id     = one(azurerm_app_service_plan.webapp_plan[*].id)
  https_only              = false
  client_affinity_enabled = false

  site_config {
    always_on         = "true"
    linux_fx_version  = join("", ["DOCKER|", data.azurerm_container_registry.acr.login_server, "/app/", var.prefix, ":latest"]) #define the images to use for you application
    health_check_path = "/" # healthD check required in order that internal app service plan loadbalancer do not loadbalance on instance down
    ip_restriction {
     virtual_network_subnet_id = var.subnet_id
    }
  }

  app_settings = local.envariables 
}

# data "azurerm_virtual_network" "swift-vnet" {
#   name                = join("-", ["vnet", var.environment])
#   resource_group_name = var.resource_group_name
# }

# data "azurerm_subnet" "swift-subnet" {
#   name                 = var.subnet_name
#   virtual_network_name = data.azurerm_virtual_network.swift-vnet.name
#   resource_group_name  = var.resource_group_name
# }

# data "azurerm_virtual_network_gateway" "swift-gw" {
#   name                = join("-", ["vpn-net-gw", var.environment])
#   resource_group_name = var.resource_group_name
# }

# requirements to join another region
# resource "azurerm_virtual_network" "sw-remote-vnet" {
#   name                = join("-", ["sw-remote-vnet", var.environment])
#   location            =var.location
#   resource_group_name = var.resource_group_name
#   address_space       = [replace(data.azurerm_virtual_network.swift-vnet.address_space[0], "/^([0-9]+)\\./", "10.")]
# }

# resource "azurerm_subnet" "sw-remote-subnet" {
#   name                 = "GatewaySubnet"
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.sw-remote-vnet.name
#   address_prefixes     = [replace(data.azurerm_subnet.swift-subnet.address_prefixes[0], "/^([0-9]+)\\./", "10.")]
# }

# resource "azurerm_subnet" "sw-remote-subnet-lnk" {
#   name                 = join("-", ["sw-subnet-lnk", var.environment])
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = azurerm_virtual_network.sw-remote-vnet.name
#   address_prefixes     = [  replace( 
#                               replace(data.azurerm_virtual_network.swift-vnet.address_space[0], "/^([0-9]+)\\./", "10."),
#                               "/(\\/.*)$/",
#                               "/23")
#                           ]
# delegation {
#     name = "delegation"
#     service_delegation {
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/action",
#       ]
#       name    = "Microsoft.Web/serverFarms"
#     }
#   }
# }

# resource "azurerm_public_ip" "sw-remote-ip" {
#   name                = join("-", ["sw-remote-ip", var.environment])
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Dynamic"
# }

# data "azurerm_subnet" "appgw-subnet" {
#   name                 = join("_", ["subnet-appgw", var.environment])
#   virtual_network_name = data.azurerm_virtual_network.swift-vnet.name
#   resource_group_name  = var.resource_group_name
# }

# resource "azurerm_virtual_network_gateway" "sw-remote-gw" {
#   name                = join("-", ["sw-remote-gw", var.environment])
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   type     = "Vpn"
#   vpn_type = "RouteBased"
#   sku      = "Basic"

#   ip_configuration {
#     public_ip_address_id          = azurerm_public_ip.sw-remote-ip.id
#     private_ip_address_allocation = "Dynamic"
#     subnet_id                     = azurerm_subnet.sw-remote-subnet.id
#   }
# }

# resource "azurerm_app_service_virtual_network_swift_connection" "swift_app_service" {   # VNET association to access private resources
#   app_service_id = azurerm_app_service.webapp_container.id
#   subnet_id      = azurerm_subnet.sw-remote-subnet-lnk.id
# }

