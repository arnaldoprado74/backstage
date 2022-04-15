resource "azurerm_network_security_group" "secgrp" {
  name                = join("-", ["sg", var.prefix, var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "secgrpo_rule" {
  count = length(var.outbound_rules)

  name                        = join("-", ["sgro", var.prefix, var.outbound_rules[count.index]["priority"], var.environment])
  priority                    = var.outbound_rules[count.index]["priority"]
  direction                   = "Outbound"
  access                      = var.outbound_rules[count.index]["access"]
  protocol                    = "Tcp"
  source_port_range           = var.outbound_rules[count.index]["source_port_range"]
  destination_port_range      = var.outbound_rules[count.index]["destination_port_range"]
  source_address_prefix       = var.outbound_rules[count.index]["source_address_prefix"]
  destination_address_prefix  = var.outbound_rules[count.index]["destination_address_prefix"]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.secgrp.name

  depends_on = [azurerm_network_security_group.secgrp]
}

resource "azurerm_network_security_rule" "secgrpi_rule" {
  count = length(var.inbound_rules)

  name                        = join("-", ["sgri", var.prefix, var.inbound_rules[count.index]["priority"], var.environment])
  priority                    = var.inbound_rules[count.index]["priority"]
  direction                   = "Inbound"
  access                      = var.inbound_rules[count.index]["access"]
  protocol                    = "Tcp"
  source_port_range           = var.inbound_rules[count.index]["source_port_range"]
  destination_port_range      = var.inbound_rules[count.index]["destination_port_range"]
  source_address_prefix       = var.inbound_rules[count.index]["source_address_prefix"]
  destination_address_prefix  = var.inbound_rules[count.index]["destination_address_prefix"]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.secgrp.name

  depends_on = [azurerm_network_security_group.secgrp]
}
