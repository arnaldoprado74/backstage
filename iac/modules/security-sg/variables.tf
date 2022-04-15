variable "environment" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "prefix" {
  type = string
}
variable "outbound_rules" {
  type = list
}
variable "inbound_rules" {
  type = list
}
