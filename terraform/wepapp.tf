
resource "azurerm_app_service_plan" "webapp" {
  name                = "${var.prefix}-appserviceplan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "webapp" {
  name                = "${var.prefix}-app-service"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.webapp.id

  site_config {
    linux_fx_version  = "DOCKER|registrydockerimages/test-app-java:latest"
  }

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL            = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME       = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD       = azurerm_container_registry.acr.admin_password
  }
}
