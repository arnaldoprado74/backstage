output "subnet-A-id" {
  value = azurerm_subnet.subnet_a.id
}
output "subnet-B-id" {
  value = azurerm_subnet.subnet_b.id
}
output "vnet-name" {
  value = azurerm_virtual_network.vnet.name
}
output "vnet-id" {
  value = azurerm_virtual_network.vnet.id
}