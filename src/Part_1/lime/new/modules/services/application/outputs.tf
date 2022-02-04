#add outputs here. 

output "public_ip_address" {
  value = "${azurerm_public_ip.rsvmss.ip_address}"
}
