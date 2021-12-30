# This resource is a Virtual Network.

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.virtual_network_name}-${var.count_number}"
  location            = var.location
  address_space       = ["${var.address_space}"]
  resource_group_name = var.resource_group
}
  