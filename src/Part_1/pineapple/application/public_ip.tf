# Every Azure Virtual Machine comes with a private IP address. You can also 
# optionally add a public IP address for Internet-facing applications and 
# demo environments like this one.
resource "azurerm_public_ip" "robot_shop_single-pip" {
  name                = "${var.resource_prefix}-ip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  domain_name_label   = var.hostname
}
