variable "selected_providers" {
  type = list
}
variable "prefix" {
  type = string
}
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
variable "admin_user" {
  type = string
}
variable "psql_sku_name" {
  type = string
}
variable "psql_storage_mb" {
  type = string
}
variable "psql_storage_backup_rd" {
  type = string
}
variable "psql_storage_backup_geor" {
  type = string
}
variable "psql_version" {
  type = string
}
variable "psql_ssl_enforcement" {
  type = string
  default = null
}
variable "subnet_id" {
  type = string
}