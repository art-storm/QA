# Container registry for docker images
resource "azurerm_container_registry" "acr" {
  name                = "registrydockerimages"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = false
}