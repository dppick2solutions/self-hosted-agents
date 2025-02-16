data "azurerm_container_registry" "acr" {
  name                = "pick2registry"
  resource_group_name = "pick2-registry-demo"
}