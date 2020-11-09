resource "azurerm_resource_group" "this" {
  name     = "pcs-${var.module_info.application}"
  location = var.module_info.location
}


resource "azurerm_automation_account" "this" {
  name                  = "pcs-automation-account"
  location              = azurerm_resource_group.this.location
  resource_group_name   = azurerm_resource_group.this.name
  sku_name              = "Basic"
  tags                  = local.merged_tags

}

resource "azurerm_automation_module" "az" {
  name                    = "az-4.8.0"
  resource_group_name     = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name

  module_link {
    uri = "https://www.powershellgallery.com/packages/Az/4.8.0"
  }
}

resource "azurerm_automation_runbook" "empty-rgs" {
  name                    = "Az-delete-empty-rgs"
  location                = azurerm_resource_group.this.location
  resource_group_name     = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Delete empty resource groups"
  runbook_type            = "PowerShell"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/thecomalley/terraform-azure/master/pcs_automation/runbooks/Az-delete-empty-rgs.ps1"
  }
}

resource "azurerm_automation_runbook" "untagged-resources" {
  name                    = "delete-untagged-resources"
  location                = azurerm_resource_group.this.location
  resource_group_name     = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "Delete empty resource groups"
  runbook_type            = "PowerShell"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/thecomalley/terraform-azure/master/pcs_automation/runbooks/Az-delete-untagged-resources.ps1"
  }
}

locals {
  # merge module_info with workspace tags
  merged_tags      = merge(var.workspace_tags,var.module_info)
}
