# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.75.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstatetest123"
    container_name       = "tfstate-prod"
    key                  = "prod.terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_env" {
  name = "rg-${var.environment}"
  location = var.location
}

module "webapp" {
    source            = "github.com/art-storm/terraform-modules/webapp/"
    rg_name           = azurerm_resource_group.rg_env.name
    location          = azurerm_resource_group.rg_env.location
    environment       = var.environment
    acr_name          = var.acr_name
    acr_rg_name       = var.acr_rg_name
    docker_image      = var.docker_image
    docker_image_tag  = var.docker_image_tag
    db_connect_string = var.db_connect_string

    plan_settings     = {
                          kind     = "Linux" # Linux or Windows
                          tier     = "Basic"
                          size     = "B1"
                        }
}
