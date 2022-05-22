output "server_name" {
  value = one(azurerm_postgresql_server.psqlserver[*].fqdn)
}

output "server_port" {
  value = 5432   # fixed
}

output "admin_username" {
  value = join("", [var.prefix, replace(regex("(.*)@.*", var.admin_user)[0],"-","")])
}