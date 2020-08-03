resource "azurerm_resource_group" "openeats" {
  name     = "rg-${var.application}-${var.environment}"
  location = var.location
}

module "storage" {
  source  = "innovationnorway/storage/azurerm"
  version = "1.1.0"

  name = "st${var.application}"
  resource_group_name = azurerm_resource_group.this.name
  kind = "FileStorage"

  shares = [
    {
      name  = "database"
      quota = 100
    },
    {
      name  = "public-ui"
      quota = 100
    },
    {
      name  = "static-files"
      quota = 100
    },
    {
      name  = "site-media"
      quota = 100
    }
  ]
}

resource "azurerm_app_service" "openeats" {
  name                = "${var.prefix}-appservice"
  location            = azurerm_resource_group.openeats.location
  resource_group_name = azurerm_resource_group.openeats.name
  app_service_plan_id = var.app_service_plan_id

  site_config {
    app_command_line = ""
    linux_fx_version = "COMPOSE|${filebase64("docker-compose.yml")}"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
}