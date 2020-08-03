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

resource "azurerm_automation_module" "azaccounts" {
  name                    = "Az.Accounts-1.9.1"
  resource_group_name     = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name

  module_link {
    uri = "https://www.powershellgallery.com/api/v2/package/Az.Accounts/1.9.1"
  }
}

resource "azurerm_automation_module" "azresources" {
  name                    = "Az.Resources-1.1.2"
  resource_group_name     = azurerm_resource_group.this.name
  automation_account_name = azurerm_automation_account.this.name

  module_link {
    uri = "https://www.powershellgallery.com/api/v2/package/Az.Resources/1.1.2"
  }
}

locals {
  # merge module_info with workspace tags
  merged_tags      = merge(var.workspace_tags,var.module_info)
}
