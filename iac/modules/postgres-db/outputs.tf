output "server_name" {
  value = one(azurerm_postgresql_server.psqlserver[*].name)
}

output "server_port" {
  value = 5432   # fixed
}

output "admin_username" {
  value = join("", [var.prefix, replace(regex("(.*)@.*", var.admin_user)[0],"-","")])
}

output "server_endpoint_ip" {
  value = azurerm_private_endpoint.db-vnet-endpoint.private_service_connection.0.private_ip_address
}