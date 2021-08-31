# Prefix for resources created by terraform
variable "prefix" {
  default = "project"
  description = "The prefix which should be used for all resources created by terraform"
}

variable "location" {
  default = "West Europe"
  description = "The Azure Region in which all resources should be created."
}

variable "admin_user" {
  default = "igor"
  description = "Default admin user"
}
