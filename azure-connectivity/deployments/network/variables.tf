variable "resource_group_name" {
  type        = string
  description = "Resource group"
  default     = "azure-connectivity"
}

variable "location" {
  type    = string
  default = ""
}

variable "app_vnet_name" {
  description = "virtual network"
  type        = string
  default     = "vnet-app"
}

variable "firewall_vnet_name" {
  description = ""
  type        = string
  default     = "vnet-firewall"
}

variable "router_vnet_name" {
  description = ""
  type        = string
  default     = "vnet-router"
}

variable "app_subnet_name" {
  description = ""
  type        = string
  default     = "AppSubnet"
}

variable "username" {
  type    = string
  default = "azureuser"
}

variable "admin_password" {
  description = "password for the VMSS"
  type        = string
  sensitive   = true
  default     = "password123"
}

variable "image_offer" {
  type    = string
  default = "debian-12"
}

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
  description = ""
  type        = string
  default     = "10.2.0.0/24"
}

variable "firewall_address_space" {
  description = ""
  type        = string
  default     = "10.1.0.0/24"
}
variable "app_address_space" {
  description = ""
  type        = string
  default     = "10.3.0.0/24"
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
  description = "router subnets map"
  type = map(object({
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
      address_space                                 = "10.2.0.0/24"
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
  description = "firewall subnets map"
  type = map(object({
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
  description = "app vm subnets map"
  type = map(object({
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
