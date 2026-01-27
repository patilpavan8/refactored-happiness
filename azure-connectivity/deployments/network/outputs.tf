output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "location" {
  value = var.location
}

output "location_short" {
  value = provider::lua::azure_region_name_short(var.region)
}

output "vnet_id" {
  value = azurerm_virtual_network.network.id
}

output "vnet_name" {
  value = azurerm_virtual_network.network.name
}

output "firewall_route_table_name" {
  value = azurerm_route_table.firewall_routes.name
}

output "firewall_private_ip" {
  value = var.enable_firewall ? azurerm_firewall.firewall[0].ip_configuration[0].private_ip_address : null
}

output "firewall_address_space" {
  value = var.enable_firewall ? azurerm_subnet.subnet_firewall.address_prefixes[0] : null
}

output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "location" {
  value = var.location
}

output "vnet_router_nat_gw_id" {
  description = "ID of the router VNet."
  value       = azurerm_virtual_network.vnet-router-nat-gw.id
}

output "vnet_firewall_id" {
  description = "ID of the firewall VNet."
  value       = azurerm_virtual_network.vnet-firewall.id
}

output "vnet_app_id" {
  description = "ID of the app VNet."
  value       = azurerm_virtual_network.vnet-app.id
}

output "nsg_allow_all_id" {
  description = "ID of the NSG allowing all traffic."
  value       = azurerm_network_security_group.nsg_allow_all.id
}

output "router_subnet_ids" {
  description = "IDs of the router subnets."
  value       = { for k, s in azurerm_subnet.router-subnet : k => s.id }
}

output "firewall_subnet_ids" {
  description = "IDs of the firewall subnets."
  value       = { for k, s in azurerm_subnet.subnet : k => s.id }
}

output "app_subnet_ids" {
  description = "IDs of the app subnets."
  value       = { for k, s in azurerm_subnet.subnet : k => s.id }
}

output "firewall_routes" {
  description = "firewall routes per region."
  value       = local.firewall_routes
}
