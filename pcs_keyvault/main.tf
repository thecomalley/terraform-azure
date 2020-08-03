data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "main" {
  name     = "pcs-${var.module_info.application}"
  location = var.module_info.location
}

resource "azurerm_key_vault" "this" {
  name                            = "keyvault-standard"
  location                        = var.module_info.location
  resource_group_name             = azurerm_resource_group.main.name
  enabled_for_disk_encryption     = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_template_deployment = true
  sku_name                        = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "a0ff0855-b6d4-435c-8b18-b78d909b9e95"

    key_permissions = [
      "list","get","create","delete","update",
    ]

    secret_permissions = [
      "list","get","set","delete",
    ]

    storage_permissions = [
      "get","set","delete","update",
    ]
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags          = local.merged_tags

}

locals {
  # merge module_info with workspace tags
  merged_tags      = merge(var.workspace_tags,var.module_info)
}
