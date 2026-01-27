# ##################################
#  NSG configuration for router VMSS
# ##################################

# resource "azurerm_network_security_group" "nsg_allow_all" {
# name = "nsg-allow-all"
# location = var.location
# resource_group_name = azurerm_resource_group.example.name

# security_rule {
# name = "allow-all-inbound"
# priority = 100
# direction = "Inbound"
# access = "Allow"
# protocol = "*"
# source_port_range = "*"
# destination_port_range = "*"
# source_address_prefix = "*"
# destination_address_prefix = "*"
#   }
# }

resource "azurerm_network_security_group" "router_vmss_nsg_allow_all_and_ssh" {
  name                = "router_vmss_nsg-allow-all"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name

  # # Inbound rule: Allow SSH (port 22) for router VMSS
  security_rule {
    name                       = "allow-ssh"
    priority                   = 110   # Higher priority than allow-all
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"   # Or limit to a specific IP/CIDR
    destination_address_prefix = "*"
  }

  # # Inbound rule
  security_rule {
    name                       = "allow-every-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"            # Any protocol
    source_port_range          = "*"            # Source port ranges
    destination_port_range     = "*"            # Destination port ranges
    source_address_prefix      = "*"            # Source Any
    destination_address_prefix = "*"            # Destination Any
  }

  # Outbound rule
  security_rule {
    name                       = "allow-every-outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"            # Any protocol
    source_port_range          = "*"            # Source port ranges
    destination_port_range     = "*"            # Destination port ranges
    source_address_prefix      = "*"            # Source Any
    destination_address_prefix = "*"            # Destination Any
  }
}

# #############################
#  NSG configuration for app VM
# #############################

resource "azurerm_network_security_group" "app_vm_nsg_allow_all" {
  name                = "app_vm_nsg-allow-all"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name

  # Inbound rule
  # security_rule {
  #   name                       = "allow-inbound"
  #   priority                   = 100
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "80"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }

  # # Inbound rule
  security_rule {
    name                       = "allow-http-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"            # Any protocol
    source_port_range          = "*"            # Source port ranges
    destination_port_range     = "*"            # Destination port ranges
    source_address_prefix      = "*"            # Source Any
    destination_address_prefix = "*"            # Destination Any
  }

  # Outbound rule
  security_rule {
    name                       = "allow-every-outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"            # Any protocol
    source_port_range          = "*"            # Source port ranges
    destination_port_range     = "*"            # Destination port ranges
    source_address_prefix      = "*"            # Source Any
    destination_address_prefix = "*"            # Destination Any
  }
}

# #######################################################
# Vnet1 router nat gw, subnet, peering, nsg configuration
# #######################################################

# VNet1 router nat gateway configuration
resource "azurerm_virtual_network" "vnet-router-nat-gw" {
  name = var.router_vnet_name

  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = [var.router_address_space]

  tags = var.tags
}

# Vnet-router-nat-gw to Vnet-firewall peering 
resource "azurerm_virtual_network_peering" "vnet_router_nat_gw_peering_to_vnet_firewall" {
  name = "peerroutertofirewall"

  resource_group_name = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.vnet-router-nat-gw.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-firewall.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# VNet1 router nat gateway subnet configuration
resource "azurerm_subnet" "router-subnet" {
  for_each             = var.router-subnets
  name                 = "subnet-${each.key}"
  resource_group_name = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.vnet-router-nat-gw.name
  address_prefixes     = [each.value.address_space]
}

# VNet1 router nat gw subnet association to network security group
resource "azurerm_subnet_network_security_group_association" "subnet-nsg-association" {
  for_each                  = var.router-subnets
  subnet_id                 = azurerm_subnet.router-subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.router_vmss_nsg_allow_all_and_ssh.id
}

# VNet1 router nat gw routing table
resource "azurerm_route_table" "vnet-router-nat-gw-routes" {
  name = "router-routingtable"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location

  route {
    name = "test-route-rt-nat-gw-app"
    address_prefix         = "10.3.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.1.2.4"
  }

  tags = var.tags
}

# VNet 1  Vnet router nat gw routing table association to subnet
resource "azurerm_subnet_route_table_association" "router_nat_gw_route_to_App_assoc" {
  for_each       = var.router-subnets
  subnet_id      = azurerm_subnet.router-subnet[each.key].id
  route_table_id = azurerm_route_table.vnet-router-nat-gw-routes.id
}

# ###################################################
# Vnet 2 firewall, subnet, peering, nsg configuration 
# ###################################################

# VNet 2  firewall configuration
resource "azurerm_virtual_network" "vnet-firewall" {
  name = var.firewall_vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = [var.firewall_address_space]

  tags = var.tags
}

# Vnet-firewall to Vnet-router-nat-gw peering
resource "azurerm_virtual_network_peering" "vnet_firewall_peering_to_vnet_router_nat_gw" {
  name = "peerfirewalltorouter"
  resource_group_name = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.vnet-firewall.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-router-nat-gw.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# Vnet-firewall to Vnet-app peering
resource "azurerm_virtual_network_peering" "vnet_firewall_peering_to_vnet_app" {
  name = "peerfirewalltoapp"

  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.vnet-firewall.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-app.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# VNet2 firewall subnet configuration
# Create Subnets dynamically from variables
resource "azurerm_subnet" "firewall-subnet" {
  for_each             = var.firewall-subnets
  name                 = "${each.key}"
  resource_group_name = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.vnet-firewall.name
  address_prefixes     = [each.value.address_space]
}

# VNet2 firewall routing table
resource "azurerm_route_table" "vnet-firewall-routes" {
  name = "firewall-routingtable"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location

  route {
    name = "test-fw-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    # next_hop_in_ip_address = "10.2.0.11"
    next_hop_in_ip_address = azurerm_lb.lbinternal.frontend_ip_configuration[0].private_ip_address
  }

  tags = var.tags
}

# VNet2  firewall routing table association to subnet
resource "azurerm_subnet_route_table_association" "firewall_route_to_nat_vm_nic_assoc" {
  for_each       = var.firewall-subnets
  subnet_id      = azurerm_subnet.firewall-subnet["fwsubnet"].id
  route_table_id = azurerm_route_table.vnet-firewall-routes.id
}

# VNet2  firewall routing table association to subnet
resource "azurerm_subnet_route_table_association" "firewall_route_to_nat_vm_nic_assoc1" {
  for_each       = var.firewall-subnets
  subnet_id      = azurerm_subnet.firewall-subnet["AzureFirewallSubnet"].id
  route_table_id = azurerm_route_table.vnet-firewall-routes.id
}

# ##############################################
# Vnet3 app, subnet, peering, nsg configuration
# ##############################################

# VNet3  app configuration
resource "azurerm_virtual_network" "vnet-app" {
  name = var.app_vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = [var.app_address_space]

  tags = var.tags
}

# Vnet-app to Vnet-firewall peering
resource "azurerm_virtual_network_peering" "vnet_app_peering_to_vnet_firewall" {
  name = "peerapptofirewall"
  resource_group_name = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.vnet-app.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet-firewall.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

# VNet3 app subnet configuration
resource "azurerm_subnet" "app-subnet" {
  for_each             = var.app-subnets
  name                 = "${each.key}"
  resource_group_name = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.vnet-app.name
  address_prefixes     = [each.value.address_space]
}

# VNet3 app subnet association to network security group
resource "azurerm_subnet_network_security_group_association" "subnet-nsg-assoc" {
  for_each                  = var.app-subnets
  subnet_id                 = azurerm_subnet.app-subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.app_vm_nsg_allow_all.id
}

# VNet3 app routing table
resource "azurerm_route_table" "vnet-app-routes" {
  name = "app-routingtable"
  resource_group_name = var.resource_group_name
  location            = var.location

  route {
    name = "router-routingtable"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.1.2.4"
  }

  tags = var.tags
}

# VNet3  Vnet app routing table association to subnet
resource "azurerm_subnet_route_table_association" "app_route_to_nat_vm_nic__assoc" {
  for_each       = var.app-subnets
  subnet_id      = azurerm_subnet.app-subnet[each.key].id
  route_table_id = azurerm_route_table.vnet-app-routes.id
}
