resource "azurerm_resource_group" "main" {
  name     = "pcs-${var.module_info.application}"
  location = var.module_info.location
}

resource "azurerm_app_service_plan" "main" {
  name                = "${var.module_info.application}-${var.size}"
  location            = var.module_info.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "Linux"
  tags                = local.merged_tags
  reserved            = true

  sku {
    tier = var.tier
    size = var.size
  }
}

locals {
  # merge module_info with workspace tags
  merged_tags      = merge(var.workspace_tags,var.module_info)
}

