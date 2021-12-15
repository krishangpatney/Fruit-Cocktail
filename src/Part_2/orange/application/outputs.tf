##############################################################################
# Outputs File

output "public_ip_address" {
  value = azurerm_public_ip.orange-pip.*.ip_address
}

output "public_DNS_address" {
  value = azurerm_public_ip.orange-pip.*.fqdn
}
