
variable "location" {
  type = string
  description = "The Azure Region in which all resources should be created."
}

variable "environment" {
  type = string
  description = "Environment"
}

variable "docker_image" {
  type = string
  description = "Docker image name"
}

variable "docker_image_tag" {
  default = "latest"
  type = string
  description = "Docker image tag"
}

variable "db_connect_string" {
  type = string
  description = "DB connection string"
}
