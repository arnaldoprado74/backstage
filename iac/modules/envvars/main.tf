variable "secrets" {
  type = map
  sensitive = true
}
locals {
    env = {
        default = {
            ####################
            # global variables #
            ####################
            tenant_user_object_id               = "0b41c045-49d6-489d-9e0f-efea3cc96716"
            admin_user                          = "admin@arnaldopradohotmail.onmicrosoft.com" # this user will be created
            allowed_external_access_addresses   = [  # for services as keyvault, db, <others>
                "177.172.5.139/32"                    # home anp              (use a curl ifconfig.me to get it)
            ]
            external_registry_url               = "ghcr.io"
            external_registry_username          = "arnaldo.prado74"
            #############################################################################################################
            enabled_ipv6                        = false
            admin_pass                          = var.secrets.admin_pass
            cert_pass                           = var.secrets.cert_pass
            core_db_user                        = "dbuser@tech-bradesco" 
            core_db_pass                        = var.secrets.core_db_pass
            core_db_name                        = "postgres"
            core_db_port                        = 5432
            far_date                            = "2999-12-31T23:59:59Z"
            subscription_id                     = var.secrets.subscription_key
            tenant_id                           = var.secrets.tenant_id            
            iac_resource_group_name             = "Default"
            iac_storage_account_name            = "iac-tech-bradesco"
            iac_container_name                  = "iac-tech-bradesco-container"
            iac_container_registry_name         = "tech-bradescoregistry"
            vpn_subnet_name                     = "GatewaySubnet" # do not change, mandatory on azure
            company_name                        = "bradescotech"
            company_domain                      = "bradescotech.tk"
            si_notification_email               = "arnaldo_prado@hotmail.com"
            si_notification_phone               = "+55-11-9"

            WKSP_SECURITY                       = "secur"
            WKSP_INFRA                          = "infra"
            WKSP_SERVICE                        = "srvc"
            WKSP_DATA                           = "data"
            WKSP_TOOLS                          = "tools"

            CLOUD_PROVIDER_AZURE                = "azure"
            CLOUD_PROVIDER_GCP                  = "gcp"
            CLOUD_PROVIDER_AWS                  = "aws"

            elkuri_kv_name                      = "elkuri"
            elkusr_kv_name                      = "elkusr"
            elkpwd_kv_name                      = "elkpwd"

            ####################
            #  env  variables  #
            ####################
            resource_group_name                 = "Default"
            location                            = "westus2"
            operations_email                    = "arnaldo_prado@hotmail.com"
            env_ref                             = "def"

            external_domain                     = "def.tech-bradesco.tk"
            internal_domain                     = "def.tech-bradesco.tk"
            dev_portal                          = ""

            net_cidr                            = "172.16.64.0/19"
            net6_cidr                           = "fc04:0:19::/58"
            subnets_A                           = "172.16.64.0/22"
            subnets6_A                          = "fc04:0:19::/64"
            subnets_B                           = "172.16.68.0/22"
            subnets6_B                          = "fc04:0:19:1::/64"
            subnets_C                           = "172.16.72.0/22"
            subnets6_C                          = "fc04:0:19:2::/64"
            subnets_D                           = "172.16.76.0/22"
            subnets6_D                          = "fc04:0:19:3::/64"
            subnets_E                           = "172.16.80.0/22"
            subnets6_E                          = "fc04:0:19:4::/64"
            subnets_elk                         = "172.16.92.0/23"
            subnets6_elk                        = "fc04:0:19:5::/64"
            vpn_subnet_cidr                     = "172.16.94.0/23"
            vpn_client_subnet_cidr              = "192.168.184.0/22"
            subnets_appgw                       = "172.16.84.0/23"
            subnets6_appgw                      = "fc04:0:19:6::/64"
            elasticsearch_ip                    = ""

            api_gateway_sku_name                = ""
            api_gateway_sku_tier                = ""
            api_gateway_autoscaling_min         = 0
            api_gateway_autoscaling_max         = 0

            vm_size                             = ""
            vm_public_ssh_key_path              = ""
            vm_username                         = ""

            sleep_tag = {
                sleeptime = "none" # daily / weekend / none
            }

            runtime_node                        = ""
            website_run_from_package            = 0
            website_node_default_version        = ""           
        }     
        dev = {
            resource_group_name                 = "dev"
            location                            = "westus"
            operations_email                    = "arnaldo_prado@hotmail.com"
            env_ref                             = "dev"

            external_domain                     = "dev.tech-bradesco.tk"
            internal_domain                     = "dev.tech-bradesco.tk"
            dev_portal                          = "/ctmgmt"

            net_cidr                            = "172.16.0.0/19"
            net6_cidr                           = "fc04:0:23::/58"
            subnets_A                           = "172.16.0.0/22"
            subnets6_A                          = "fc04:0:23::/64"
            subnets_B                           = "172.16.4.0/22"
            subnets6_B                          = "fc04:0:23:1::/64"
            subnets_C                           = "172.16.8.0/22"
            subnets6_C                          = "fc04:0:23:2::/64"
            subnets_D                           = "172.16.12.0/22"
            subnets6_D                          = "fc04:0:23:3::/64"
            subnets_E                           = "172.16.16.0/22"
            subnets6_E                          = "fc04:0:23:4::/64"
            subnets_elk                         = "172.16.28.0/23"
            subnets6_elk                        = "fc04:0:23:5::/64"
            vpn_subnet_cidr                     = "172.16.30.0/23"
            vpn_client_subnet_cidr              = "192.168.188.0/22"
            subnets_appgw                       = "172.16.20.0/23"
            subnets6_appgw                      = "fc04:0:23:6::/64"
            elasticsearch_ip                    = "10.1.242.4"
         
            api_gateway_sku_name                = "Standard_v2"
            api_gateway_sku_tier                = "Standard_v2"
            api_gateway_autoscaling_min         = 2
            api_gateway_autoscaling_max         = 100

            vm_size                             = "Standard_B2s"
            vm_public_ssh_key_path              = "${path.module}/../../certs/machines/azure_linux_dev.pub"
            vm_username                         = "r1st"

            sleep_tag = {
                sleeptime = "none" # daily / weekend / none
            }

            runtime_node                        = "node"
            website_run_from_package            = 1
            website_node_default_version        = "~12"           
        }      
        pre = {
            resource_group_name                 = "pre"
            location                            = "westus2"
            operations_email                    = "arnaldo_prado@hotmail.com"
            env_ref                             = "pre"

            external_domain                     = "pre.tech-bradesco.tk"
            internal_domain                     = "pre.tech-bradesco.tk"
            dev_portal                          = "/ctmgmt"

            net_cidr                            = "172.16.100.0/19"
            net6_cidr                           = "fc04:0:25::/58"
            subnets_A                           = "172.16.100.0/22"
            subnets6_A                          = "fc04:0:25::/64"
            subnets_B                           = "172.16.104.0/22"
            subnets6_B                          = "fc04:0:25:1::/64"
            subnets_C                           = "172.16.108.0/22"
            subnets6_C                          = "fc04:0:25:2::/64"
            subnets_D                           = "172.16.112.0/22"
            subnets6_D                          = "fc04:0:25:3::/64"
            subnets_E                           = "172.16.116.0/22"
            subnets6_E                          = "fc04:0:25:4::/64"
            subnets_elk                         = "172.16.128.0/23"
            subnets6_elk                        = "fc04:0:25:5::/64"
            vpn_subnet_cidr                     = "172.16.130.0/23"
            vpn_client_subnet_cidr              = "192.168.192.0/22"
            subnets_appgw                       = "172.16.120.0/23"
            subnets6_appgw                      = "fc04:0:25:6::/64"
            elasticsearch_ip                    = "10.1.242.4"

            api_gateway_sku_name                = "Standard_v2" # "WAF_v2"
            api_gateway_sku_tier                = "Standard_v2" # "WAF_v2"
            api_gateway_autoscaling_min         = 2
            api_gateway_autoscaling_max         = 100

            vm_size                             = "Standard_B2s"
            vm_public_ssh_key_path              = "${path.module}/../../certs/machines/azure_linux_pre.pub"
            vm_username                         = "r1st"

            sleep_tag = {
                sleeptime = "none" # daily / weekend / none
            }

            runtime_node                        = "node"
            website_run_from_package            = 1
            website_node_default_version        = "~12"           
        }

        "1st" = {
            resource_group_name                 = "1st"
            location                            = "westus2"
            operations_email                    = "arnaldo_prado@hotmail.com"
            env_ref                             = "1st"

            external_domain                     = "1st.tech-bradesco.tk"
            internal_domain                     = "1st.tech-bradesco.tk"
            dev_portal                          = "/ctmgmt"

            net_cidr                            = "172.16.200.0/19"
            net6_cidr                           = "fc04:0:125::/58"
            subnets_A                           = "172.16.200.0/22"
            subnets6_A                          = "fc04:0:125::/64"
            subnets_B                           = "172.16.204.0/22"
            subnets6_B                          = "fc04:0:125:1::/64"
            subnets_C                           = "172.16.208.0/22"
            subnets6_C                          = "fc04:0:125:2::/64"
            subnets_D                           = "172.16.212.0/22"
            subnets6_D                          = "fc04:0:125:3::/64"
            subnets_E                           = "172.16.216.0/22"
            subnets6_E                          = "fc04:0:125:4::/64"
            subnets_elk                         = "172.16.228.0/23"
            subnets6_elk                        = "fc04:0:125:5::/64"
            vpn_subnet_cidr                     = "172.16.230.0/23"
            vpn_client_subnet_cidr              = "192.168.196.0/22"
            subnets_appgw                       = "172.16.220.0/23"
            subnets6_appgw                      = "fc04:0:125:6::/64"
            elasticsearch_ip                    = "10.1.242.4"

            api_gateway_sku_name                = "Standard_v2" # "WAF_v2"
            api_gateway_sku_tier                = "Standard_v2" # "WAF_v2"
            api_gateway_autoscaling_min         = 2
            api_gateway_autoscaling_max         = 100

            vm_size                             = "Standard_D2ds_v5"
            vm_public_ssh_key_path              = "${path.module}/../../certs/machines/azure_linux_1st.pub"
            vm_username                         = "r1st"

            sleep_tag = {
                sleeptime = "none" # daily / weekend / none
            }

            runtime_node                        = "node"
            website_run_from_package            = 1
            website_node_default_version        = "~12"           
        }

        "2nd" = {
            resource_group_name                 = "2nd"
            location                            = "westus2"
            operations_email                    = "arnaldo_prado@hotmail.com"
            env_ref                             = "2nd"

            external_domain                     = "2nd.tech-bradesco.tk"
            internal_domain                     = "2nd.tech-bradesco.tk"
            dev_portal                          = "/ctmgmt"

            net_cidr                            = "172.16.200.0/19"
            net6_cidr                           = "fc04:0:125::/58"
            subnets_A                           = "172.16.200.0/22"
            subnets6_A                          = "fc04:0:125::/64"
            subnets_B                           = "172.16.204.0/22"
            subnets6_B                          = "fc04:0:125:1::/64"
            subnets_C                           = "172.16.208.0/22"
            subnets6_C                          = "fc04:0:125:2::/64"
            subnets_D                           = "172.16.212.0/22"
            subnets6_D                          = "fc04:0:125:3::/64"
            subnets_E                           = "172.16.216.0/22"
            subnets6_E                          = "fc04:0:125:4::/64"
            subnets_elk                         = "172.16.228.0/23"
            subnets6_elk                        = "fc04:0:125:5::/64"
            vpn_subnet_cidr                     = "172.16.230.0/23"
            vpn_client_subnet_cidr              = "192.168.200.0/22"
            subnets_appgw                       = "172.16.220.0/23"
            subnets6_appgw                      = "fc04:0:125:6::/64"
            elasticsearch_ip                    = ""

            api_gateway_sku_name                = "Standard_v2" # "WAF_v2"
            api_gateway_sku_tier                = "Standard_v2" # "WAF_v2"
            api_gateway_autoscaling_min         = 2
            api_gateway_autoscaling_max         = 100

            vm_size                             = "Standard_D2ds_v5"
            vm_public_ssh_key_path              = "${path.module}/../../certs/machines/azure_linux_1st.pub"
            vm_username                         = "r2nd"

            sleep_tag = {
                sleeptime = "none" # daily / weekend / none
            }

            runtime_node                        = "node"
            website_run_from_package            = 1
            website_node_default_version        = "~12"           
        }
    }
}
locals {
    baseref         = local.env["default"]
    environment     = "${replace(terraform.workspace, "/.*-/", "")}"
    environmentvars = "${contains(keys(local.env), local.environment) ? local.environment : "default"}"
    envref          = local.env[local.environmentvars]
    workspace       = "${merge(local.baseref, local.envref)}"
}
