resource "azurerm_resource_group" "this" {
  name     = "app-${var.module_info.application}"
  location = var.module_info.location
}

# module "database" {
#   source  = "app.terraform.io/malleynet/database/mysql"
#   version = "0.0.1"

#   db_name = var.module_info.application
#   mariadb_server_fqdn = var.mariadb_server_fqdn
#   mariadb_server_name = var.mariadb_server_name
#   mariadb_server_password = var.mariadb_server_password
#   mariadb_server_username = var.mariadb_server_username
# }

module "storage" {
  source                   = "app.terraform.io/malleynet/storage/azurerm"
  version                  = "0.0.3"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = var.module_info.location
  name                     = "appdata${var.module_info.application}"
  kind                     = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.merged_tags

  shares = [
    {
      name  = "config"
      quota = 100
    }
  ]
}

resource "azurerm_app_service" "this" {
  name                = "app-${var.module_info.application}"
  location            = var.module_info.location
  resource_group_name = azurerm_resource_group.this.name
  app_service_plan_id = var.app_service_plan_id

  site_config {
    app_command_line = ""
    always_on        = true
    linux_fx_version = "DOCKER|linuxserver/freshrss:latest"
  }

  #environment variables
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://index.docker.io"
    "IS_DOCKER"                           = "true"
    "APP_URL"                             = "Europe/London"
  }
  
  #volumes
  storage_account {
    name                    = module.storage.name
    type                    = "AzureFiles"
    account_name            = module.storage.name
    share_name              = "config"
    access_key              = module.storage.primary_access_key
    mount_path              = "/config"
  }
  
  tags                      = local.merged_tags
}

locals {
  # merge module_info with workspace tags
  merged_tags      = merge(var.workspace_tags,var.module_info)
}