# Configure resource group
resource "azurerm_resource_group" "this" {
  name     = "rg-${var.app_info.type}-${var.app_info.application}"
  location = var.app_info.location
}

resource "azurerm_app_service" "this" {
  name                = "app-${var.app_info.application}-${var.app_info.environment}"
  location            = var.app_info.location
  resource_group_name = azurerm_resource_group.this.name
  app_service_plan_id = var.app_service_plan_id

  site_config {
    linux_fx_version         = "NODE|10.14"
    app_command_line         = "npm install"
  }
  
  tags                      = local.merged_tags
}

locals {
  # set app specific tags
  app_tags = {
    application   = var.app_info.application
    environment   = var.app_info.environment
  }
  # merge with workspace tags
  merged_tags      = merge(var.workspace_tags,local.app_tags)
}