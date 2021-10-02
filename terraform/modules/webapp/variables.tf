variable "rg_name" {
  type = string
  description = "Webapp resource group name"
}

variable "location" {
  type = string
  description = "The Azure Region in which webapp should be created."
}

variable "environment" {
  type = string
  description = "Environment"
}

variable "plan_settings" {
  type        = map
  description = "Definition of the dedicated plan to use"

  default = {
    kind     = "Linux"
    tier     = "Free"
    size     = "F1"
  }
}

variable "acr_name" {
  type = string
  description = "Docker registry name"
}

variable "acr_rg_name" {
  type = string
  description = "Docker registry resource group name"
}

variable "docker_image" {
  type = string
  description = "Docker image name"
}

variable "docker_image_tag" {
  type = string
  description = "Docker image tag"
}

variable "db_connect_string" {
  type = string
  description = "DB connection string"
}
