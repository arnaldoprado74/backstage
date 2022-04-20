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
variable "core_db_pass" {
  type = string
  sensitive = true
}
variable "psql_sku_name" {
  type = string
}
variable "psql_storage_mb" {
  type = number
}
variable "psql_storage_backup_rd" {
  type = number
}
variable "psql_storage_backup_geor" {
  type = bool
}
variable "psql_version" {
  type = string
}
variable "psql_ssl_enforcement" {
  type = bool
}
variable "subnet_id" {
  type = string
}