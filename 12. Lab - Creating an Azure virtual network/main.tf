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

resource "azurerm_resource_group" "dev-rg" {
  name     = "WEdev"
  location = "West Europe"
}

# Here we are creating a storage account.
# The storage account service has more properties and hence there are more arguements we can specify here

resource "azurerm_storage_account" "WEstrg" {
  name                     = "westrg1996"
  resource_group_name      = azurerm_resource_group.dev-rg.name
  location                 = azurerm_resource_group.dev-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  shared_access_key_enabled = "true"
  public_network_access_enabled = "true"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["100.0.0.1"]
    virtual_network_subnet_ids = [azurerm_subnet.WEvnet-subnet1.id]
  }

tags = {
    environment = "development"
  }
  depends_on = [
    azurerm_subnet.WEvnet-subnet1
  ]
}

resource "azurerm_storage_container" "test" {
  name = "test"
  storage_account_name = azurerm_storage_account.WEstrg.name
  container_access_type = "private"
  depends_on = [
    azurerm_storage_account.WEstrg
  ]
}

resource "azurerm_storage_blob" "sample" {
  name = "sample"
  storage_account_name = azurerm_storage_account.WEstrg.name
  storage_container_name = azurerm_storage_container.test.name
  type = "Block"
  source = "sample.txt"
  depends_on = [
    azurerm_storage_container.test
  ]
}

resource "azurerm_virtual_network" "WEvnet" {
  name                = "WEvnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name
}

resource "azurerm_subnet" "WEvnet-subnet1" {
  name                 = "WEvnet-subnet1"
  resource_group_name  = azurerm_resource_group.dev-rg.name
  virtual_network_name = azurerm_virtual_network.WEvnet.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
  depends_on = [
    azurerm_virtual_network.WEvnet
  ]
}
