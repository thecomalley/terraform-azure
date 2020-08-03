output "server_fqdn" {
  value = azurerm_mariadb_server.main.fqdn
}

output "server_name" {
  value = azurerm_mariadb_server.main.name
}

output "server_username" {
  value = "${azurerm_mariadb_server.main.administrator_login}@${azurerm_mariadb_server.main.name}"
}

output "server_password" {
  value = azurerm_mariadb_server.main.administrator_login_password
}