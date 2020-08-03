######################
### Core Variables ###
######################

variable "workspace_tags" {}
variable "app_info" {
  type = map
}

########################
### Specific Variables #
########################

variable "store_secret" {}
variable "key_vault_id" {}