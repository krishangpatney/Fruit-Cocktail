terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

# Configure the Azure Provider
provider "azurerm" {
	subscription_id 	= var.subscription_id
	features {}
}

# Use a created resource group
data "azurerm_resource_group" "krishangs_resource" {
	name = "${var.resource_prefix}"
	#location = var.node_location  	
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "robot_shop_vnet" {
	name = "${var.resource_prefix}-vnet"
	resource_group_name = data.azurerm_resource_group.krishangs_resource.name
	location = var.node_location
	address_space = var.node_address_space
}

# Create a subnets within the virtual network
resource "azurerm_subnet" "robot_shop_subnet" {
	name = "${var.resource_prefix}-subnet"
	resource_group_name = data.azurerm_resource_group.krishangs_resource.name
	virtual_network_name = azurerm_virtual_network.robot_shop_vnet.name
	address_prefix = var.node_address_prefix
}

resource "azurerm_public_ip" "robot_shop_ip" {
  name                = "${var.resource_prefix}-pip"
  location            = var.node_location
  resource_group_name = data.azurerm_resource_group.krishangs_resource.name
  allocation_method   = "Dynamic"
  domain_name_label   = "krishangs-domain1"
}

resource "azurerm_lb" "example" {
  name                = "${var.resource_prefix}-lb"
  location            = var.node_location
  resource_group_name = data.azurerm_resource_group.krishangs_resource.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.robot_shop_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "example" {
  resource_group_name = data.azurerm_resource_group.krishangs_resource.name
  loadbalancer_id     = azurerm_lb.example.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "example" {
  resource_group_name = data.azurerm_resource_group.krishangs_resource.name
  loadbalancer_id     = azurerm_lb.example.id
  name                = "ssh-probe"
  protocol            = "Tcp"
  port                = 22
}

resource "azurerm_lb_nat_pool" "example" {
  resource_group_name = data.azurerm_resource_group.krishangs_resource.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port_start            = 80
  frontend_port_end              = 8080
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_linux_virtual_machine_scale_set" "main" {
  name                            = "robotshop-vmss"
  resource_group_name             = "krishangs_resource"
  location                        = "UK South"
  sku                             = "Standard_F2"
  instances                       = 1
  admin_username                  = "adminuser"
  admin_password                  = "P@ssw0rd1234!"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

 network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.robot_shop_subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.example.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.example.id]
    }
  }

  depends_on = [azurerm_lb_probe.example]
  
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  extension {
    name                       = "CustomScript"
    publisher                  = "Microsoft.Azure.Extensions"
    type                       = "CustomScript"
    type_handler_version       = "2.0"
    auto_upgrade_minor_version = true

	protected_settings = <<PROTECTED_SETTINGS
		{
		"commandToExecute": "sudo chmod +x setup.sh && sudo ./setup.sh"
		}
	PROTECTED_SETTINGS

	settings = <<SETTINGS
		{
			"fileUris": [
			"https://gist.githubusercontent.com/krishangpatney/c05315a21d4258b3034c9097b68c5de3/raw/4226a83e22c283812ae8a351c043d8baf9896f72/setup.sh"
			]
		}
	SETTINGS
	}
}


# https://gist.githubusercontent.com/krishangpatney/c05315a21d4258b3034c9097b68c5de3/raw/133b14afa93533dcecb301eb64e9495474f4c16f/setup.sh