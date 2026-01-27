resource "azurerm_public_ip" "nat_publicip" {
  name                = "pip-nat-gw"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat_gw" {
  name                = "natgw-router"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  sku_name            = "Standard"
}

# #############################################
# Attach Public IP to NAT Gateway (Outbound IP)
# #############################################

resource "azurerm_nat_gateway_public_ip_association" "nat_gw_pip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_publicip.id
}

# ###################################
# Attach NAT Gateway to router subnet
# ###################################

# resource "azurerm_subnet_nat_gateway_association" "assoc" {
#   subnet_id      = azurerm_subnet.router-subnet["routersubnet"].id
#   nat_gateway_id = azurerm_nat_gateway.nat_gw.id
# }
