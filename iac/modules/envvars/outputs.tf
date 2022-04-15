########################
### global variables ###
########################
output "tenant_user_object_id" {
  value = local.baseref["tenant_user_object_id"]
}
output "admin_user" {
  value = local.baseref["admin_user"]
}
output "allowed_external_access_addresses" {
  value = local.baseref["allowed_external_access_addresses"]
}
### 
output "enabled_ipv6" {
  value = local.baseref["enabled_ipv6"]
}
output "admin_pass" {
  value = local.baseref["admin_pass"]
}
output "cert_pass" {
  value = local.baseref["cert_pass"]
}
output "core_db_user" {
  value = local.baseref["core_db_user"]
}
output "core_db_pass" {
  value = local.baseref["core_db_pass"]
}
output "core_db_name" {
  value = local.baseref["core_db_name"]
}
output "core_db_port" {
  value = local.baseref["core_db_port"]
}
output "far_date" {
  value = local.baseref["far_date"]
}
output "subscription_id" {
  value = local.baseref["subscription_id"]
}
output "tenant_id" {
  value = local.baseref["tenant_id"]
}
output "iac_resource_group_name" {
  value = local.baseref["iac_resource_group_name"]
}
output "iac_storage_account_name" {
  value = local.baseref["iac_storage_account_name"]
}
output "iac_container_name" {
  value = local.baseref["iac_container_name"]
}
output "iac_container_registry_name" {
  value = local.baseref["iac_container_registry_name"]
}
output "vpn_subnet_name" {
  value = local.baseref["vpn_subnet_name"]
}
output "company_name" {
  value = local.baseref["company_name"]  
}
output "company_domain" {
  value = local.baseref["company_domain"]  
}
output "si_notification_email" {
  value = local.baseref["si_notification_email"]
}
output "si_notification_phone" {
  value = local.baseref["si_notification_phone"]
}
###
output "WKSP_SECURITY" {
  value = local.baseref["WKSP_SECURITY"]
}
output "WKSP_INFRA" {
  value = local.baseref["WKSP_INFRA"]
}
output "WKSP_SERVICE" {
  value = local.baseref["WKSP_SERVICE"]
}
output "WKSP_DATA" {
  value = local.baseref["WKSP_DATA"]
}
output "WKSP_TOOLS" {
  value = local.baseref["WKSP_TOOLS"]
}
###
output "CLOUD_PROVIDER_AZURE" {
  value = local.baseref["CLOUD_PROVIDER_AZURE"]  
}
output "CLOUD_PROVIDER_GCP" {
  value = local.baseref["CLOUD_PROVIDER_GCP"]  
}
output "CLOUD_PROVIDER_AWS" {
  value = local.baseref["CLOUD_PROVIDER_AWS"]  
}
###
output "elkuri_kv_name" {
  value = local.baseref["elkuri_kv_name"]
}
output "elkusr_kv_name" {
  value = local.baseref["elkuri_kv_name"]
}
output "elkpwd_kv_name" {
  value = local.baseref["elkpwd_kv_name"]
}
output "environment" {
  value = local.environment
}
########################
### common variables ###
########################
output "resource_group_name" {
  value = local.workspace["resource_group_name"]
}
output "location" {
  value = local.workspace["location"]
}
output "operations_email" {
  value = local.workspace["operations_email"]
}
output "env_ref" {
  value = local.workspace["env_ref"]
}
output "external_domain" {
  value = local.workspace["external_domain"]
}
output "internal_domain" {
  value = local.workspace["internal_domain"]
}
output "dev_portal" {
  value = local.workspace["dev_portal"]
}
output "net_cidr" {
  value = local.workspace["net_cidr"]
}
output "net6_cidr" {
  value = local.workspace["net6_cidr"]
}
output "subnets_A" {
  value = local.workspace["subnets_A"]
}
output "subnets6_A" {
  value = local.workspace["subnets6_A"]
}
output "subnets_B" {
  value = local.workspace["subnets_B"]
}
output "subnets6_B" {
  value = local.workspace["subnets6_B"]
}
output "subnets_C" {
  value = local.workspace["subnets_C"]
}
output "subnets6_C" {
  value = local.workspace["subnets6_C"]
}
output "subnets_D" {
  value = local.workspace["subnets_D"]
}
output "subnets6_D" {
  value = local.workspace["subnets6_D"]
}
output "subnets_E" {
  value = local.workspace["subnets_E"]
}
output "subnets6_E" {
  value = local.workspace["subnets6_E"]
}
output "subnets_elk" {
  value = local.workspace["subnets_elk"]
}
output "subnets6_elk" {
  value = local.workspace["subnets6_elk"]
}
output "vpn_subnet_cidr" {
  value = local.workspace["vpn_subnet_cidr"]
}
output "vpn_client_subnet_cidr" {
  value = local.workspace["vpn_client_subnet_cidr"]
}
output "subnets_appgw" {
  value = local.workspace["subnets_appgw"]
}
output "subnets6_appgw" {
  value = local.workspace["subnets6_appgw"]
}
output "elasticsearch_ip" {
  value = local.workspace["elasticsearch_ip"]
}
output "api_gateway_sku_name" {
  value = local.workspace["api_gateway_sku_name"]
}
output "api_gateway_sku_tier" {
  value = local.workspace["api_gateway_sku_tier"]
}
output "api_gateway_autoscaling_min" {
  value = local.workspace["api_gateway_autoscaling_min"]
}
output "api_gateway_autoscaling_max" {
  value = local.workspace["api_gateway_autoscaling_max"]
}
output "vm_size" {
  value = local.workspace["vm_size"]
}
output "vm_public_ssh_key_path" {
  value = local.workspace["vm_public_ssh_key_path"]
}
output "vm_username" {
  value = local.workspace["vm_username"]
}
output "sleep_tag" {
  value = local.workspace["sleep_tag"]
}
output "runtime_node" {
  value = local.workspace["runtime_node"]
}
output "website_run_from_package" {
  value = local.workspace["website_run_from_package"]
}
output "website_node_default_version" {
  value = local.workspace["website_node_default_version"]
}