output "registry_login_server" {
  value = one(azurerm_container_registry.acr[*].login_server)
}