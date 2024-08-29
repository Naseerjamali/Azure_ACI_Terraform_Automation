output "container_ipv4_address" {
  value = azurerm_container_group.container.ip_address
}

output "fqdn" {
  value = azurerm_container_group.container.fqdn
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}
