# A network interface. This is required by the azurerm_virtual_machine 
# resource. Terraform will let you know if you're missing a dependency.
resource "azurerm_network_interface" "orange" {
  name                = "${var.resource_prefix}-${var.variation}"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "${var.resource_prefix}-ipconfig-${var.variation}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.orange-pip.id
  }
}
