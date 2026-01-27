variable "resource_group_name" {
  type        = string
  description = "Resource group for all resources"
  default     = "rg-infra-1199-tf-lab"
}

variable "location" {
  type    = string
  default = "Italy North"
}

variable "app_vnet_name" {
  description = "Name of the existing virtual network"
  type        = string
  default     = "vnet-pavan-app-deployed"
}

variable "firewall_vnet_name" {
  description = "Name of the existing virtual network"
  type        = string
  default     = "vnet-pavan-firewall"
}

variable "router_vnet_name" {
  description = "Name of the existing virtual network"
  type        = string
  default     = "vnet-pavan-router"
}

variable "app_subnet_name" {
  description = "Name of the subnet to attach NICs to"
  type        = string
  default     = "AppSubnet"
}

variable "username" {
  type    = string
  default = "azureuser"
}

variable "admin_password" {
  description = "Admin password for the VMSS"
  type        = string
  sensitive   = true
  default     = "testadmin"
}

variable "image_offer" {
  type    = string
  default = "debian-12"
}

# variable "name_fields" {
#   type = object({
#     client      = string
#     environment = string
#     region      = string
#     info        = optional(string)
#   })
#   description = "Fields for construction resources names. Note that the info field gets overridden by some resources"
# }

variable "vm_size" {
  type    = string
  default = "Standard_D2als_v6"
}

variable "vm_ssh_keys" {
  type = set(string)
}

variable "firewall_public_address_id" {
  type     = string
  nullable = true
  default  = null
}

variable "sku_tier" {
  type     = string
  default  = "Standard"
}

variable "firewall_zones" {
  type    = list(string)
  default = ["1", "2", "3"]
}

variable "enable_firewall" {
  type = bool
  default = false
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "vmss_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "sku" {
  type    = string
  default = "Standard"
}

variable "os_disk_size" {
  type    = number
  default = 30
}

variable "image_sku" {
  type    = string
  default = "12-gen2"
}

variable "router_address_space" {
  description = "CIDR block for the virtual network"
  type        = string
  default     = "10.2.0.0/16"
}

variable "firewall_address_space" {
  description = "CIDR block for the virtual network"
  type        = string
  default     = "10.1.0.0/16"
}
variable "app_address_space" {
  description = "CIDR block for the virtual network"
  type        = string
  default     = "10.3.0.0/16"
}

variable "tags" {
  type        = map(string)
  description = "Tags for all resources"
  default     = {}
}

# #####################
# Router Nat GW subnets 
# #####################

variable "router-subnets" {
  description = "Map of subnets to create including required Azure firewall subnets."
  type = map(object({
    # address_prefix = string
    address_space                                 = string
    service_endpoints                             = list(string)
    private_link_service_network_policies_enabled = bool
    delegations = optional(map(object({
      service_name    = string
      service_actions = list(string)
    })))
  }))

  default = {
    routersubnet = {
      address_space                                 = "10.2.0.0/16"
      service_endpoints                             = []
      private_link_service_network_policies_enabled = true
      delegations                                   = {}
    }
  }
}

# #################
# Firewall subnets 
# #################

variable "firewall-subnets" {
  description = "Map of Azure firewall subnets configuration."
  type = map(object({
    # address_prefix = string
    address_space                                 = string
    service_endpoints                             = list(string)
    private_link_service_network_policies_enabled = bool
    delegations = optional(map(object({
      service_name    = string
      service_actions = list(string)
    })))
  }))

  default = {
    fwsubnet = {
      address_space                                 = "10.1.1.0/24"
      service_endpoints                             = []
      private_link_service_network_policies_enabled = true
      delegations                                   = {}
    }

    AzureFirewallSubnet = {
      address_space                                 = "10.1.2.0/26"
      service_endpoints                             = []
      private_link_service_network_policies_enabled = true
      delegations                                   = {}
    }

    AzureFirewallManagementSubnet = {
      address_space                                 = "10.1.0.0/26"
      service_endpoints                             = []
      private_link_service_network_policies_enabled = true
      delegations                                   = {}
    }
  }
}

# ############
# app subnets 
# ############

variable "app-subnets" {
  description = "Map of subnets to create including required app subnets."
  type = map(object({
    # address_prefix = string
    address_space                                 = string
    service_endpoints                             = list(string)
    private_link_service_network_policies_enabled = bool
    delegations = optional(map(object({
      service_name    = string
      service_actions = list(string)
    })))
  }))

  default = {
    AppSubnet = {
      address_space                                 = "10.3.1.0/24"
      service_endpoints                             = []
      private_link_service_network_policies_enabled = true
      delegations                                   = {}
    }
  }
}
