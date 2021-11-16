##############################################################################
# Outputs File
 
output "public_ip_address" {
  value = "${azurerm_public_ip.robot_shop_single-pip.*.ip_address}"
}
