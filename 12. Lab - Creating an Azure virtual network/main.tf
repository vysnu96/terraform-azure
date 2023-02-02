terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.41.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id   = "dbfe3dd4-9b11-406b-9907-c8f3f10c7afe"
  tenant_id         = "f2612ad3-a841-4f9f-a06f-d0e492223312"
  client_id         = "7c5a5703-e2d2-4d20-85e6-fddfc583c328"
  client_secret     = "d978Q~X2D7v4WUAUgwOw_vR.WOWOQ22RrupJGdzS"
  
}


locals {
  resource_group="app-grp"
  location="North Europe"
}

resource "azurerm_resource_group" "app_grp"{
  name=local.resource_group
  location=local.location
}

resource "azurerm_virtual_network" "app_network" {
  name                = "app-network"
  location            = local.location
  resource_group_name = azurerm_resource_group.app_grp.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "SubnetA"
    address_prefix = "10.0.1.0/24"
  }  
  tags {
    env="development"
  }
}
