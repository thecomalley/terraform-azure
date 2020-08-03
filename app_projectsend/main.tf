resource "azurerm_resource_group" "this" {
  name     = "rg-${var.application}-${var.environment}"
  location = var.location
}

module "storage" {
  source               = "../../../modules/azurerm/storage"
  
  resource_group_name      = azurerm_resource_group.this.name
  location                 = var.location
  name                     = "st${var.application}"
  kind                     = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  shares = [
    {
      name  = "app"
      quota = 100
    }
  ]
}

# create statping database on the shared db server
module "mysql_database" {
  source              = "../../../modules/mysql/database"

  db_name             = "statping"
 
  mariadb_server_fqdn     = var.mariadb_server_fqdn
  mariadb_server_name     = var.mariadb_server_name
  mariadb_server_username = var.mariadb_server_username
  mariadb_server_password = var.mariadb_server_password
}

resource "azurerm_app_service" "this" {
  name                = "app-${var.application}-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  app_service_plan_id = var.app_service_plan_id

  site_config {
    app_command_line = ""
    always_on        = true
    linux_fx_version = "DOCKER|statping/statping:latest"
  }

  #environment variables
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://index.docker.io"
    "DB_CONN"                             = "mysql"
    "DB_HOST"                             = var.mariadb_server_fqdn
    "DB_PORT"                             = 3306
    "DB_USER"                             = module.mysql_database.db_username
    "DB_PASS"                             = module.mysql_database.db_password
    "DB_DATABASE"                         = module.mysql_database.db_name
    "NAME"                                = "app-${var.application}-${var.environment}"
    "DESCRIPTION"                         = "Status Page for monitoring websites and applications with beautiful graphs, analytics, and plugins"
    "DOMAIN"                              = "statping.malleynet.co.nz"
    "ADMIN_USER"                          = "statping"
    "ADMIN_PASSWORD"                      = "statping"
    "ADMIN_EMAIL"                         = "info@admin.com"
    "IS_DOCKER"                           = "true"
  }

  #volumes
  storage_account {
    name                    = module.storage.name
    type                    = "AzureFiles"
    account_name            = module.storage.name
    share_name              = "app"
    access_key              = module.storage.primary_access_key
    mount_path              = "/app"
  }
  
  tags                      = local.tags
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