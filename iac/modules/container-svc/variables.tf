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
variable "subnet_id" {
  type = string
}

variable "registry_name" {
  type = string
  default = ""
}

variable "service_env" {
  type = map
}

variable "service_port" {
  type = number
}

variable "image_path" {
  type = string
}

variable "health_check_path" {
  type = string
}

variable "external_registry_url" {
  type = string
}

variable "external_registry_username" {
  type = string
}

variable "external_registry_password" {
  type = string
}