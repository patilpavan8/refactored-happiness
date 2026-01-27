# ##########################
# A Public IP for management
# ##########################

resource "azurerm_public_ip" "fw_mgmt_pip" {
  name                = "fw-mgmt-pip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {

  name = "testfirewall"

  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.sku_tier
  threat_intel_mode   = "Alert"

  ip_configuration { 
    name                 = "fw-ipconfig"
    subnet_id = azurerm_subnet.firewall-subnet["AzureFirewallSubnet"].id
    public_ip_address_id = azurerm_public_ip.fw_public_ip.id
  }

  management_ip_configuration {
  name      = "fw-mgmt-ipconfig"
  subnet_id = azurerm_subnet.firewall-subnet["AzureFirewallManagementSubnet"].id
  public_ip_address_id = azurerm_public_ip.fw_mgmt_pip.id 
}

  # ##########################
  # attach the firewall policy
  # ##########################

  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
}

resource "azurerm_public_ip" "fw_public_ip" {
  name                = "fw-pip"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = var.sku
}

# #####################
# firewall policy rules
# #####################

resource "azurerm_firewall_policy_rule_collection_group" "allow_everything_rcg" {
  name               = "DefaultNetworkRuleCollectionGroup"

  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 100

  network_rule_collection {
    name     = "allow-everything-test"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "allow-everything"
      protocols             = ["Any"]
      source_addresses      = ["*"]      # Add all required IPs
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }
}

# ######################################################################################################
# SNAT configuration block: private_ip_ranges list instructs firewall not to SNAT those ranges.
# Setting "0.0.0.0/0" -> never SNAT (all destinations treated as private ranges for SNAT decision).
# Reference - https://learn.microsoft.com/en-us/azure/firewall/snat-private-range?utm_source=chatgpt.com
# ######################################################################################################

resource "azurerm_firewall_policy" "fw_policy" {
  name                = "fw-policy"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name

  sku = var.sku

  # #############################################################################################
  # SNAT disabled
  # In many azurerm versions we can configure firewall private_ip_ranges (or in firewall policy) 
  # to effectively disable SNAT by specifying 0.0.0.0/0.
  # #############################################################################################
  private_ip_ranges = ["0.0.0.0/0"]

  tags = var.tags
}