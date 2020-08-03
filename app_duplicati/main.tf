# Configure resource group
resource "azurerm_resource_group" "this" {
  name     = "rg-${var.app_info.application}"
  location = var.app_info.location
}

# Configure storage_container modules
module "appdata" {
  source              = "../../../modules/azurerm/storage_container"
  store_secret        = var.store_secret
  key_vault_id        = var.key_vault_id
  name                = "st${var.app_info.application}appdata"
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.merged_tags
}

module "backup" {
  source              = "../../../modules/azurerm/storage_container"
  store_secret        = var.store_secret
  key_vault_id        = var.key_vault_id
  name                = "st${var.app_info.application}backup"
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.merged_tags
}

module "documents" {
  source              = "../../../modules/azurerm/storage_container"
  store_secret        = var.store_secret
  key_vault_id        = var.key_vault_id
  name                = "st${var.app_info.application}documents"
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.merged_tags
}

module "photos" {
  source              = "../../../modules/azurerm/storage_container"
  store_secret        = var.store_secret
  key_vault_id        = var.key_vault_id
  name                = "st${var.app_info.application}photos"
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.merged_tags
}

locals {
  # merge app_info with workspace tags
  merged_tags      = merge(var.workspace_tags,var.app_info)
}