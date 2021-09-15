
resource "azurerm_app_service_plan" "webapp" {
  name                = "ASP-app-appjava-test"
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
  name                = "app-appjava-test"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.webapp.id

  site_config {
    linux_fx_version  = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.docker_image}:${var.docker_image_tag}"
    use_32_bit_worker_process = true
  }

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL            = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME       = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD       = azurerm_container_registry.acr.admin_password
    DOCKER_CUSTOM_IMAGE_NAME              = "${var.docker_image}:${var.docker_image_tag}"
    JDBC_DATABASE_URL                     = var.db_connect_string
  }
}
