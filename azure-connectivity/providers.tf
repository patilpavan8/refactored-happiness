terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 4.16.0"
    }

    lua = {
      source  = "opentofu/lua"
      version = "= 0.0.2"
    }

    azapi = {
      source  = "azure/azapi"
      version = ">= 2.5.0"
    }
  }

  required_version = ">= 1.9"
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = false
    }
  }

  subscription_id = "xxxxxxxx"
  tenant_id       = "xxxxxxxx"
}
