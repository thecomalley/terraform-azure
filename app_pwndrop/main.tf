resource "azurerm_resource_group" "main" {
  name     = "${var.module_info.type}-${var.module_info.application}"
  location = var.module_info.location
}

resource "azurerm_storage_account" "main" {
  name                     = "appdata${var.module_info.application}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "main" {
  name                 = "pwndrop-config"
  storage_account_name = azurerm_storage_account.main.name
  quota                = 50
}

resource "azurerm_container_group" "main" {
  name                = "pwndrop"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "public"
  dns_name_label      = "aci-label"
  os_type             = "Linux"

  container {
    name   = "pwndrop"
    image  = "linuxserver/pwndrop"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 8080
      protocol = "TCP"
    }

    volume {
      name       = "config"
      mount_path = "/config"
      read_only  = false
      share_name = azurerm_storage_share.main.name
      storage_account_name = azurerm_storage_account.main.name
      storage_account_key  = azurerm_storage_account.main.primary_access_key
    }

  }

  tags = {
    environment = "testing"
  }
}