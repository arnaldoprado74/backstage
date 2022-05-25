resource "azurerm_virtual_network" "vnet" {
  name                = join("-", ["vnet", var.environment])
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.enabled_ipv6 ? [var.net_cidr, var.net6_cidr] : [var.net_cidr]
}

# Security Groups
module "security-sg-sub-a" {
  source = "../../modules/security-sg"
  
  environment         = var.environment
  resource_group_name = var.resource_group_name
  location            = var.location
  prefix              = "snet-a"
  outbound_rules      = [zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [110, "Allow", "*", "*", "*", "*"])]
  inbound_rules       = [zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [100, "Allow", "*", "*", "AzureLoadBalancer", "VirtualNetwork"]),
                          zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [101, "Allow", "*", "*", "VirtualNetwork", "VirtualNetwork"]),
                          zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [102, "Allow", "*", "*", var.vpn_subnet_cidr, "VirtualNetwork"]),
                          zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [110, "Deny", "*", "*", "*", "*"])]
}

module "security-sg-sub-b" {
  source = "../../modules/security-sg"
  
  environment           = var.environment
  resource_group_name   = var.resource_group_name
  location              = var.location
  prefix                = "snet-b"
  outbound_rules        = [zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [110, "Allow", "*", "*", "*", "*"])]
  inbound_rules         = [zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [100, "Allow", "*", "*", "AzureLoadBalancer", "*"]),
                            zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [101, "Allow", "*", "*", "VirtualNetwork", "VirtualNetwork"]),
                            zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [102, "Allow", "*", "*", var.vpn_subnet_cidr, "VirtualNetwork"]),
                            zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [103, "Allow", "*", "3443", "ApiManagement", "VirtualNetwork"]),
                            zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [110, "Deny", "*", "*", "*", "*"])]
}

module "security-sg-sub-c" {
  source = "../../modules/security-sg"
  
  environment           = var.environment
  resource_group_name   = var.resource_group_name
  location              = var.location
  prefix                = "snet-c"
  outbound_rules        = [zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [110, "Allow", "*", "*", "*", "*"])]
  inbound_rules         = [zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [100, "Allow", "*", "*", "AzureLoadBalancer", "*"]),
                            zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [101, "Allow", "*", "*", "VirtualNetwork", "VirtualNetwork"]),
                            zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [102, "Allow", "*", "*", var.vpn_subnet_cidr, "VirtualNetwork"]),
                            zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [103, "Allow", "*", "3443", "ApiManagement", "VirtualNetwork"]),
                            zipmap(["priority", "access", "source_port_range", "destination_port_range", "source_address_prefix", "destination_address_prefix"], [110, "Deny", "*", "*", "*", "*"])]
}

# Subnets
resource "azurerm_subnet" "subnet_a" {
  name                 = join("-", ["a", "public", var.environment])
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.enabled_ipv6 ? [var.subnets_A, var.subnets6_A] : [var.subnets_A]
  service_endpoints    = var.public_service_endpoints
  delegation {
    name = "delegation"
    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_a_sg" {
  subnet_id                 = azurerm_subnet.subnet_a.id
  network_security_group_id = module.security-sg-sub-a.security-group-id
}

resource "azurerm_subnet" "subnet_b" {
  name                 = join("-", ["b", "private", var.environment])
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.enabled_ipv6 ? [var.subnets_B, var.subnets6_B] : [var.subnets_B]
  service_endpoints    = var.private_service_endpoints

   delegation {
    name = "delegation"
    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_b_sg" {
  subnet_id                 = azurerm_subnet.subnet_b.id
  network_security_group_id = module.security-sg-sub-b.security-group-id
}

resource "azurerm_subnet" "subnet_c" {
  name                 = join("-", ["c", "private", var.environment])
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.enabled_ipv6 ? [var.subnets_C, var.subnets6_C] : [var.subnets_C]
  service_endpoints    = setunion(var.private_service_endpoints, ["Microsoft.Sql"])

  #  delegation {
  #   name = "delegation"
  #   service_delegation {
  #     actions = [
  #       "Microsoft.Network/virtualNetworks/subnets/action",
  #     ]
  #     name = "Microsoft.Web/serverFarms"
  #   }
  # }
}

resource "azurerm_subnet_network_security_group_association" "subnet_c_sg" {
  subnet_id                 = azurerm_subnet.subnet_c.id
  network_security_group_id = module.security-sg-sub-c.security-group-id
}

# DNS

# resource "azurerm_private_dns_zone_virtual_network_link" "vnet_dns" {
#   name                  = join("-", ["vnet", "dns", var.environment])
#   resource_group_name   = var.resource_group_name
#   private_dns_zone_name = var.internal_domain
#   virtual_network_id    = azurerm_virtual_network.vnet.id
# }

