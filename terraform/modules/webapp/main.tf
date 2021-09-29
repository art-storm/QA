terraform {
  required_version = ">= 1.0.6"
  required_providers {
    azurerm = ">= 2.75"
  }
}

data "azurerm_container_registry" "acr" {
  name = var.acr_name
  resource_group_name = var.acr_rg_name
}

resource "azurerm_app_service_plan" "webapp" {
  name                = "ASP-app-appjava-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name
  kind                = var.plan_settings["kind"]
  reserved            = true

  sku {
    tier = var.plan_settings["tier"]
    size = var.plan_settings["size"]
  }
}

resource "azurerm_app_service" "webapp" {
  name                = "app-appjava-${var.environment}"
  location            = var.location
  resource_group_name = var.rg_name
  app_service_plan_id = azurerm_app_service_plan.webapp.id

  site_config {
    linux_fx_version  = "DOCKER|${data.azurerm_container_registry.acr.login_server}/${var.docker_image}:${var.docker_image_tag}"
    use_32_bit_worker_process = true
  }

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL            = "https://${data.azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME       = data.azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD       = data.azurerm_container_registry.acr.admin_password
    DOCKER_CUSTOM_IMAGE_NAME              = "${var.docker_image}:${var.docker_image_tag}"
    JDBC_DATABASE_URL                     = var.db_connect_string
  }
}
