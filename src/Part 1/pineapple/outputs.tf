##############################################################################
# Outputs File
 

output "public_dns" {
  value = "${azurerm_public_ip.robot_shop_single-pip.fqdn}"
}

output "App_Server_URL" {
  value = "http://${azurerm_public_ip.robot_shop_single-pip.fqdn}"
}

output "public_ip_address" {
  value = "${azurerm_public_ip.robot_shop_single-pip.*.ip_address}"
}
