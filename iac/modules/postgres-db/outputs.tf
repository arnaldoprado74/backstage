output "server_name" {
  value = one(azurerm_postgresql_server.psqlserver[*].name)
}

output "server_port" {
  value = 5432   # fixed
}
