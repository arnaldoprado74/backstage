# terraform {
#   backend "azurerm" {}
# }

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

  selected_providers        = ["azure"]
  prefix                    = "bs"
  environment               = module.envvars.environment
  resource_group_name       = module.envvars.resource_group_name
  location                  = module.envvars.location
  company_name              = module.envvars.company_name
  admin_user                = module.envvars.admin_user
  core_db_pass              = module.envvars.core_db_pass
  psql_sku_name             = "B_Gen5_1"
  psql_version              = "9.6"
  psql_storage_mb           = 65536
  psql_storage_backup_rd    = 7 # retention days
  psql_storage_backup_geor  = false
  psql_ssl_enforcement      = true
  subnet_id                 = one(module.networking[*].subnet-B-id)
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
  registry_name             = join("", ["bs", "acr", module.envvars.environment])
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
  registry_name             = join("", ["bs", "acr", module.envvars.environment])
}