variable "location" {
  default     = "AustraliaEast"
}

variable "application" {}

variable "mariadb_server_fqdn" {}
variable "mariadb_server_name" {}
variable "mariadb_server_username" {}
variable "mariadb_server_password" {}


variable "environment" {
  default     = "dev"
}

variable "app_service_plan_id" {}

variable "workspace_tags" {}