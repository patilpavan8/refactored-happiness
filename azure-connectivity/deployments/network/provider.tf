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

module "ids" {
  source = "git repo url"
}

module "functions" {
  source = "git repo url"
}

provider "lua" {
  lua = module.functions.content
}
