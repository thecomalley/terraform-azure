# Configure the Azure Provider
provider "azurerm" {
  version = "=2.4.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}

# Configure remote state backend
terraform {
  backend "remote" {
    organization = "malleynet"
    workspaces {
      name = "azure_pcs_prod"
    }
  }
}

module "pcs_networking" {
  source                = "./pcs_networking"
  
  workspace_tags        = var.workspace_tags
  module_info = {
    application         = "networking" 
    location            = "AustraliaSoutheast"
  }  
}

module "pcs_automation" {
  source                = "./pcs_automation"
  
  workspace_tags        = var.workspace_tags
  module_info = {
    application         = "automation" 
    location            = "AustraliaSoutheast"
    type                = "platform_common services"
  }  
}

module "pcs_app-service" {
  source                = "./pcs_app-service"
  
  workspace_tags        = var.workspace_tags
  module_info = {
    application         = "app-service" 
    location            = "AustraliaSoutheast"
  }  
}

module "pcs_keyvault" {
  source                = "./pcs_keyvault"
  
  workspace_tags        = var.workspace_tags
  module_info = {
    application         = "keyvault" 
    location            = "AustraliaSoutheast"
  }  
}

module "pcs_mariadb" {
  source                = "./pcs_mariadb"
  
  store_secret                 = true
  key_vault_id                 = module.pcs_keyvault.id
  administrator_login          = "omadmin"
  administrator_login_password = "dsasdlnQwdTgasd314"
  ssl_enforcement              = "Disabled"

  workspace_tags               = var.workspace_tags
  module_info = {
    application                = "mariadb" 
    location                   = "AustraliaEast"
  }  
}

######################
###  Applications  ###
######################

module "app_freshrss" {
  source                = "./app_freshrss"

  app_service_plan_id     = module.pcs_app-service.plan_id
  mariadb_server_fqdn     = module.pcs_mariadb.server_fqdn
  mariadb_server_name     = module.pcs_mariadb.server_name 
  mariadb_server_username = module.pcs_mariadb.server_username
  mariadb_server_password = module.pcs_mariadb.server_password
  
  workspace_tags        = var.workspace_tags
  module_info = {
    application         = "freshrss" 
    location            = "AustraliaSoutheast"
  }  
}