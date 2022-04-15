variable "environment" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "company_name" {
  type = string
}
variable "net_cidr" {
  type = string
}
variable "subnets_A" {
  type = string
}
variable "subnets_B" {
  type = string
}
variable "subnets_C" {
  type = string
}
variable "subnets_D" {
  type = string
}
variable "subnets_E" {
  type = string
}
variable "subnets_cache" {
  type = string
  default = null
}
variable "net6_cidr" {
  type = string
}
variable "subnets6_A" {
  type = string
}
variable "subnets6_B" {
  type = string
}
variable "subnets6_C" {
  type = string
}
variable "subnets6_D" {
  type = string
}
variable "subnets6_E" {
  type = string
}
variable "subnets6_func" {
  type = string
  default = null
}
variable "subnets6_cache" {
  type = string
  default = null
}
variable "private_service_endpoints" {
  type = list
}
variable "public_service_endpoints" {
  type = list
  default = null
}
variable "external_domain" {
  type = string
}
variable "internal_domain" {
  type = string
}
variable "tenant_id" {
  type = string
}
variable "tenant_ad" {
  type = map
  default = {}
}
variable "subscription_id" {
  type = string
}
variable "admin_user" {
  type = string
}
variable "admin_pass" {
  type = string
}
variable "provisioning_resource_group_name" {
  type = string
}
variable "provisioning_storage_account_name" {
  type = string
}
variable "provisioning_container_name" {
  type = string
}
variable "vpn_subnet_cidr" {
  type = string
}
variable "kv_id" {
  type = string
}
variable "enabled_ipv6" {
  type = bool
}