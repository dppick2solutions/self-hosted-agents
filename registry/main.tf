## ------
## Resource Group
## ------
resource "azurerm_resource_group" "default" {
  name     = "pick2-registry-demo"
  location = "Central US"
}

## ------
## Registry
## ------
resource "azurerm_container_registry" "acr" {
  name                = "pick2registry"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  sku                 = "Basic"
  admin_enabled       = true
}