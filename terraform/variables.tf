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

variable "docker_image" {
  default = "crappjavatest/test-app-java"
  description = "Docker image name"
}

variable "docker_image_tag" {
  default = "latest"
  description = "Docker image tag"
}

variable "db_connect_string" {
  default = "jdbc:postgresql://137.116.192.131:5432/qa_db"
  description = "Docker image tag"
}
