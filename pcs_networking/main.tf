resource "azurerm_resource_group" "main" {
  name     = "pcs-${var.module_info.application}"
  location = var.module_info.location
}

resource "azurerm_virtual_network" "main" {
  name                = "OMA-AZURE-VNET"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.3.0.0/16"]

  subnet {
    name           = "Azure-1030"
    address_prefix = "10.3.0.0/24"
  }

  subnet {
    name           = "Azure-1031"
    address_prefix = "10.3.1.0/24"
  }

  subnet {
    name           = "Azure-1032"
    address_prefix = "10.3.2.0/24"
  }

  tags = local.merged_tags
}


locals {
  # merge module_info with workspace tags
  merged_tags      = merge(var.workspace_tags,var.module_info)
}

