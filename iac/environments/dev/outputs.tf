output "resource_group_name" {
  value = module.envvars.resource_group_name
}

output "vnet_name" {
  value = one(module.networking[*].vnet-name)
}

output "vnet_id" {
  value = one(module.networking[*].vnet-id)
}

output "location" {
  value = module.envvars.location
}

# output "vpn_net_gw_id" {
#   value = one(module.vpn[*].vpn_net_gw_id)
# }

output "debug_string" {
  value = ""
}