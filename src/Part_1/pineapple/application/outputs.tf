##############################################################################
# Outputs File

output "public_ip_address" {
  value = azurerm_public_ip.robot_shop_single-pip.*.ip_address
}

output "public_DNS_address" {
  value = azurerm_public_ip.robot_shop_single-pip.*.fqdn
}

# output "application_name" {
#   value = azurerm_virtual_machine.name
# }