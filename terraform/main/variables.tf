# Prefix for resources created by terraform
variable "prefix" {
  default = "project"
  type = string
  description = "The prefix which should be used for all resources created by terraform"
}

variable "rg-main" {
  default = "rg-main"
  type = string
  description = "The main resource group."
}

variable "location" {
  default = "West Europe"
  type = string
  description = "The Azure Region in which all resources should be created."
}

variable "admin_user" {
  default = "igor"
  type = string
  description = "Default admin user"
}
