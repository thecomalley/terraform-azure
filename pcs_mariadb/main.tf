resource "azurerm_resource_group" "main" {
  name     = "pcs-${var.module_info.application}"
  location = var.module_info.location
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

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  version                      = var.mariadb_version
  ssl_enforcement              = var.ssl_enforcement
  tags                         = local.merged_tags
}

resource "azurerm_key_vault_secret" "module" {
  count                        = var.store_secret ? 1 : 0
  name                         = azurerm_mariadb_server.main.administrator_login
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
