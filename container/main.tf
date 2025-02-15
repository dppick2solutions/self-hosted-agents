resource "azurerm_resource_group" "default" {
  name     = "self-hosted-agents"
  location = "Central US"
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "agent-logs"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "default" {
  name                       = "pick2-container-environment"
  location                   = azurerm_resource_group.default.location
  resource_group_name        = azurerm_resource_group.default.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
}

resource "azurerm_container_app" "default" {
  name                         = "ado-self-hosted-agent"
  container_app_environment_id = azurerm_container_app_environment.default.id
  resource_group_name          = azurerm_resource_group.default.name
  revision_mode                = "Single"

  template {
    container {
      name   = "agent"
      image  = "${var.image_name}:v1"
      cpu    = 2
      memory = "8Gi"
    }
  }
}