# terraform {
#   backend "azurerm" {}
# }

locals {
  BACKEND_SECRET = random_id.backstage_secret.b64_std
}

provider "azurerm" {
  features {}
}

module "envvars" {
  source = "../../modules/envvars"

  secrets = var.p_secrets
}

module "resgrp" {
  count  = join("-", [module.envvars.WKSP_INFRA, module.envvars.environment]) == terraform.workspace ? 1 : 0
  source = "../../modules/resgrp"

  resource_group_name = module.envvars.resource_group_name
  location            = module.envvars.location
}

module "storage" {
  count  = join("-", [module.envvars.WKSP_INFRA, module.envvars.environment]) == terraform.workspace ? 1 : 0
  source = "../../modules/storage-account-basic"

  resource_group_name       = module.envvars.resource_group_name
  location                  = module.envvars.location
  environment               = module.envvars.environment
  company_name              = module.envvars.company_name
  prefix                    = "main"
  allow_blob_public_access  = false
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication       = "GRS"

  depends_on = [ module.resgrp[0] ]
}

module "kv" {
  count  = join("-", [module.envvars.WKSP_INFRA, module.envvars.environment]) == terraform.workspace ? 1 : 0
  source = "../../modules/kv"

  environment             = module.envvars.environment
  resource_group_name     = module.resgrp[0].main_resource_group_name
  location                = module.envvars.location
  company_name            = module.envvars.company_name
  tenant_id               = module.envvars.tenant_id
  tenant_user_object_id   = module.envvars.tenant_user_object_id
   keyvault_secrets = {
   }
   allowed_external_access_addresses = module.envvars.allowed_external_access_addresses
}

module "networking" {
  count  = join("-", [module.envvars.WKSP_INFRA, module.envvars.environment]) == terraform.workspace ? 1 : 0
  source = "../../modules/networking"

  environment                        = module.envvars.environment
  resource_group_name                = module.resgrp[0].main_resource_group_name
  location                           = module.envvars.location
  company_name                       = module.envvars.company_name
  net_cidr                           = module.envvars.net_cidr
  subnets_A                          = module.envvars.subnets_A
  subnets_B                          = module.envvars.subnets_B
  subnets_C                          = module.envvars.subnets_C
  subnets_D                          = module.envvars.subnets_D
  subnets_E                          = module.envvars.subnets_E
  net6_cidr                          = module.envvars.net6_cidr
  subnets6_A                         = module.envvars.subnets6_A
  subnets6_B                         = module.envvars.subnets6_B
  subnets6_C                         = module.envvars.subnets6_C
  subnets6_D                         = module.envvars.subnets6_D
  subnets6_E                         = module.envvars.subnets6_E
  private_service_endpoints          = ["Microsoft.Web"]
  public_service_endpoints           = ["Microsoft.Web"]
  external_domain                    = module.envvars.external_domain
  internal_domain                    = module.envvars.internal_domain
  tenant_id                          = module.envvars.tenant_id
  subscription_id                    = module.envvars.subscription_id
  admin_user                         = module.envvars.admin_user
  admin_pass                         = module.envvars.admin_pass
  provisioning_resource_group_name   = module.envvars.iac_resource_group_name
  provisioning_storage_account_name  = module.envvars.iac_storage_account_name
  provisioning_container_name        = module.envvars.iac_container_name
  vpn_subnet_cidr                    = module.envvars.vpn_subnet_cidr
  kv_id                              = null
  enabled_ipv6                       = module.envvars.enabled_ipv6
}

module "postgres-db-backstage" {
  count  = join("-", [module.envvars.WKSP_INFRA, module.envvars.environment]) == terraform.workspace ? 1 : 0
  source = "../../modules/postgres-db" 

  selected_providers                = ["azure"]
  prefix                            = "bs"
  environment                       = module.envvars.environment
  resource_group_name               = module.envvars.resource_group_name
  location                          = module.envvars.location
  company_name                      = module.envvars.company_name
  admin_user                        = module.envvars.admin_user
  core_db_pass                      = module.envvars.core_db_pass
  psql_sku_name                     = "B_Gen5_1"
  psql_version                      = "11"
  psql_storage_mb                   = 65536
  psql_storage_backup_rd            = 7 # retention days
  psql_storage_backup_geor          = false
  psql_ssl_enforcement              = true
  subnet_id                         = one(module.networking[*].subnet-B-id)
  allowed_external_access_addresses = module.envvars.allowed_external_access_addresses
}

module "container-registry" {
  count  = join("-", [module.envvars.WKSP_INFRA, module.envvars.environment]) == terraform.workspace ? 1 : 0
  source = "../../modules/container-registry" 

  selected_providers        = ["azure"]
  prefix                    = "bs"
  environment               = module.envvars.environment
  resource_group_name       = module.envvars.resource_group_name
  location                  = module.envvars.location
  company_name              = module.envvars.company_name
  admin_user                = module.envvars.admin_user
}

resource "random_id" "backstage_secret" {
  byte_length = 24
}

data "azurerm_key_vault_secret" "github_cr_pat" {
  name         = "github-cr-pat"
  key_vault_id = one(module.kv[*].kv_id)

  depends_on = [
    module.kv
  ]
}

data "azurerm_key_vault_secret" "github_token" {
  name         = "github-token"
  key_vault_id = one(module.kv[*].kv_id)
  depends_on = [
    module.kv
  ]
}

module "container-service" {
  count  = join("-", [module.envvars.WKSP_INFRA, module.envvars.environment]) == terraform.workspace ? 1 : 0
  source = "../../modules/container-svc" 

  selected_providers        = ["azure"]
  prefix                    = "bs"
  environment               = module.envvars.environment
  resource_group_name       = module.envvars.resource_group_name
  location                  = module.envvars.location
  company_name              = module.envvars.company_name
  admin_user                = module.envvars.admin_user
  subnet_id                 = one(module.networking[*].subnet-B-id)
  service_env               = {
      POSTGRES_HOST             = one(module.postgres-db-backstage[*].server_name)
      POSTGRES_PORT             = one(module.postgres-db-backstage[*].server_port)
      POSTGRES_USER             = "bsadmin@bs-srv-dev" #one(module.postgres-db-backstage[*].admin_username)
      POSTGRES_PASSWORD         = module.envvars.core_db_pass
      BACKEND_SECRET            = local.BACKEND_SECRET
      AUTH_GITLAB_CLIENT_ID     = "1d70f853d3989722eb52ae9fe9a561b140e4927f94828e86ea2a603a059a8720"
      AUTH_GITLAB_CLIENT_SECRET = "d06e894535f3d087decf44f90a68d4bde4583ec5b57cfe0baf8755a81951a76f"
      AUTH_GITHUB_CLIENT_ID     = "2387574e4120a6dac08e"
      AUTH_GITHUB_CLIENT_SECRET = "0e4054f2c6eb29b3190a7c5050544980c0db709b"
      GITLAB_TOKEN              = "glpat-jsiH3f7HGUn3tW2GxGJu"
      GITHUB_TOKEN              = data.azurerm_key_vault_secret.github_token.value
  }
  service_port               = 7007
  image_path                 = "ghcr.io/arnaldoprado74/backstage-be:latest"
  health_check_path          = "/healthcheck"
  external_registry_url      = module.envvars.external_registry_url
  external_registry_username = module.envvars.external_registry_username
  external_registry_password = data.azurerm_key_vault_secret.github_cr_pat.value
}

module "container-service-fe" {
  count  = join("-", [module.envvars.WKSP_INFRA, module.envvars.environment]) == terraform.workspace ? 1 : 0
  source = "../../modules/container-svc" 

  selected_providers        = ["azure"]
  prefix                    = "bsfe"
  environment               = module.envvars.environment
  resource_group_name       = module.envvars.resource_group_name
  location                  = module.envvars.location
  company_name              = module.envvars.company_name
  admin_user                = module.envvars.admin_user
  subnet_id                 = one(module.networking[*].subnet-B-id)
  service_env               = {
    BACKEND_SECRET            = local.BACKEND_SECRET
  }
  service_port              = 3000
  image_path                = "ghcr.io/arnaldoprado74/backstage-fe:latest"
  health_check_path         = "/healthcheck"
  external_registry_url      = module.envvars.external_registry_url
  external_registry_username = module.envvars.external_registry_username
  external_registry_password = data.azurerm_key_vault_secret.github_cr_pat.value
}