resource "azurerm_resource_group" "main" {
  name     = "pcs-${var.module_info.application}"
  location = var.module_info.location
}

resource "random_string" "random" {
  length = 16
  special = true
  override_special = "/@£$"
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "_%@"
}

resource "azurerm_mariadb_server" "main" {
  name                = "mariadb-svr-basic"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.module_info.location
  sku_name            = var.sku_name

  storage_profile {
    storage_mb                 = var.storage_mb
    backup_retention_days      = var.backup_retention_days
    geo_redundant_backup       = var.geo_redundant_backup
    auto_grow                  = var.auto_grow
  }

  administrator_login          = random_string.random.result
  administrator_login_password = random_password.password.result
  version                      = var.mariadb_version
  ssl_enforcement              = var.ssl_enforcement
  tags                         = local.merged_tags
}

resource "azurerm_key_vault_secret" "username" {
  count                        = var.store_secret ? 1 : 0
  name                         = "${azurerm_mariadb_server.main.name}-username"
  content_type                 = "username"
  value                        = azurerm_mariadb_server.main.administrator_login
  key_vault_id                 = var.key_vault_id
}

resource "azurerm_key_vault_secret" "password" {
  count                        = var.store_secret ? 1 : 0
  name                         = "${azurerm_mariadb_server.main.name}-password"
  content_type                 = "password"
  value                        = azurerm_mariadb_server.main.administrator_login_password
  key_vault_id                 = var.key_vault_id
}

resource "azurerm_mariadb_firewall_rule" "fw1" {
  name                = "allow-access-to-azure-services"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mariadb_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0" 
}

locals {
  # merge module_info with workspace tags
  merged_tags      = merge(var.workspace_tags,var.module_info)
}
