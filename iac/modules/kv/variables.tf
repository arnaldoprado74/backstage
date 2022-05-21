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
variable "keyvault_secrets" {
  type = map
}
variable "tenant_id" {
  type = string
}
variable "tenant_user_object_id" {
  type = string
}
variable "allowed_external_access_addresses" {
  type = list
}