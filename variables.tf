variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "workspace_tags" {
  type = map
  default = {
    deployment    = "terraform_cloud"
    environment   = "production"
    }
}
