output "server_name" {
  value = one(azurerm_postgresql_server.psqlserver[*].fqdn)
}

output "server_port" {
  value = 5432   # fixed
}
