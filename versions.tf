terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    mysql = {
      source = "terraform-providers/mysql"
    }
  }
  required_version = ">= 0.13"
}
