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

resource "azurerm_user_assigned_identity" "container" {
  location            = azurerm_resource_group.default.location
  name                = "self-hosted-container-identity"
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_role_assignment" "container_registry_reader" {
  scope = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id = azurerm_user_assigned_identity.container.principal_id
}

resource "azurerm_container_app_environment" "environment" {
  name                       = "pick2-container-environment"
  location                   = azurerm_resource_group.default.location
  resource_group_name        = azurerm_resource_group.default.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
  workload_profile {
    name = "Consumption"
    workload_profile_type = "Consumption"
  }
}

resource "azurerm_container_app" "app" {
  name                         = "ado-self-hosted-agent"
  container_app_environment_id = azurerm_container_app_environment.environment.id
  resource_group_name          = azurerm_resource_group.default.name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"

  identity {
    type = "UserAssigned"
    identity_ids = [ azurerm_user_assigned_identity.container.id ]
  }

  ingress {
    external_enabled = true
    target_port = 443
    traffic_weight {
      percentage = 100
      latest_revision = true
    }
  }

  registry {
    server = data.azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.container.id
  }

  template {
    container {
      name   = "agent"
      image  = "${var.image_name}:v1"
      cpu    = 2.0
      memory = "4Gi"
      env {
        name = "AZP_URL"
        value = var.azure_devops_url
      }
      env {
        name = "AZP_TOKEN"
        value = var.azure_devops_personal_access_token
      }
    }
  }

  

  depends_on = [ azurerm_role_assignment.container_registry_reader ]
}