###########################
## Core Module Variables ##
###########################

variable "module_info" {
  type = map
}

variable "workspace_tags" {
    type = map
}

#############################
## Module Config Variables ##
#############################

# Required

variable "store_secret" {}
variable "key_vault_id" {}
variable "administrator_login" {}
variable "administrator_login_password" {}

# Optional

variable "name" {
  default = "mariadb-svr"
}

variable "sku_name" {
  description = "The name of the SKU, follows the tier + family + cores pattern"
  default     = "B_Gen5_1"
}

variable "storage_mb" {
  description = "Possible values are between 5120 MB (5GB) and 1024000MB (1TB) for the Basic SKU"
  default     = "5120"
}

variable "backup_retention_days" {
  description = "Backup retention days for the server, supported values are between 7 and 35 days"
  default     = "7"
}

variable "geo_redundant_backup" {
  description = "Enable Geo-redundant or not for server backup. Valid values for this property are Enabled or Disabled"
  default     = "Disabled"
}

variable "auto_grow" {
  description = "Defines whether autogrow is enabled or disabled for the storage. Valid values are Enabled or Disabled"
  default     = "Enabled"
}

variable "mariadb_version" {
  description = "Specifies the version of MariaDB to use. Possible values are 10.2 and 10.3"
  default     = "10.3"
}

variable "ssl_enforcement" {
  description = "Specifies if SSL should be enforced on connections. Possible values are Enabled and Disabled"
  default     = "Enabled"
}