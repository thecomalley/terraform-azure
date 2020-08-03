resource "azurerm_resource_group" "main" {
  name     = "pcs-${var.module_info.application}"
  location = var.module_info.location
}


module "activity_logs" {
    source  = "aztfmod/caf-activity-logs/azurerm"
    version = "2.0.0"
    
    resource_group_name   = azurerm_resource_group.name
    name                  = "activity_logs"
    convention            = "cafclassic"
    location              = var.locations
    tags                  = local.tags
    logs_retention        = 30    
}

module "diagnostics_logs" {
    source  = "aztfmod/caf-diagnostics-logging/azurerm"
    version = "2.0.1"

    resource_group_name   = azurerm_resource_group.name
    name                  = "diagnostics_logs"
    convention            = "cafclassic"
    location              = var.locations
    tags                  = local.tags
}

module "log_analytics" {
    source  = "aztfmod/caf-log-analytics/azurerm"
    version = "2.0.1"

    name                              = var.name
    solution_plan_map                 = var.solution_plan_map
    resource_group_name               = var.rg
    prefix                            = var.prefix
    location                          = var.location
    tags                              = var.tags

}

locals {
  # set app specific tags
  app_tags = {
    application   = var.application
    environment   = var.environment
  }
  # merge with workspace tags
  tags            = merge(var.workspace_tags,local.app_tags)
}