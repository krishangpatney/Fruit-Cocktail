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
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "rsvmss" {
	name = "${var.resource_prefix}-vnet"
	resource_group_name = data.azurerm_resource_group.krishangs_resource.name
	location = var.node_location
	address_space = var.node_address_space
}

# Create a subnets within the virtual network
resource "azurerm_subnet" "rsvmss" {
	name = "${var.resource_prefix}-subnet"
	resource_group_name = data.azurerm_resource_group.krishangs_resource.name
	virtual_network_name = azurerm_virtual_network.rsvmss.name
	address_prefix = var.node_address_prefix
}

resource "azurerm_public_ip" "rsvmss" {
  name                = "${var.resource_prefix}-pip"
  location            = var.node_location
  resource_group_name = data.azurerm_resource_group.krishangs_resource.name
  allocation_method   = "Dynamic"
  domain_name_label   = "krishangs-domain1"
}

resource "azurerm_lb" "rsvmss" {
  name                = "${var.resource_prefix}-lb"
  location            = var.node_location
  resource_group_name = data.azurerm_resource_group.krishangs_resource.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.rsvmss.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id     = azurerm_lb.rsvmss.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "rsvmss" {
  resource_group_name = data.azurerm_resource_group.krishangs_resource.name
  loadbalancer_id     = azurerm_lb.rsvmss.id
  name                = "ssh-probe"
  port                = 80
}

resource "azurerm_lb_rule" "lbnatrule" {
  resource_group_name = data.azurerm_resource_group.krishangs_resource.name
  loadbalancer_id                = azurerm_lb.rsvmss.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.rsvmss.id
}

data "template_file" "script" {
  template = "${file("cloud-init.yml")}"
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "cloud-init.yml"
    content      = "${data.template_file.script.rendered}"
  }
}

resource "azurerm_virtual_machine_scale_set" "main" {
  name                            = "robotshop-vmss"
  resource_group_name             = "krishangs_resource"
  location                        = "UK South"

  upgrade_policy_mode             = "Automatic"

  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = 2
  } 

  os_profile_linux_config {
    disable_password_authentication = false
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun          = 0
    caching        = "ReadWrite"
    create_option  = "Empty"
    disk_size_gb   = 10
  }

 network_profile {
    name    = "rsnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.rsvmss.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      # load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.example.id]
    }
  }
  os_profile {
    computer_name_prefix = "vmlab"
    admin_username       = var.admin_username
    admin_password       = var.admin_password
    custom_data          = "${data.template_cloudinit_config.config.rendered}"
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
        "https://gist.githubusercontent.com/krishangpatney/c05315a21d4258b3034c9097b68c5de3/raw/a1d03b6fe4d40e8b51d0506d2e32b0d60e2d0325/setup.sh"
        ]
      }
    SETTINGS
    }
  }


# https://gist.githubusercontent.com/krishangpatney/c05315a21d4258b3034c9097b68c5de3/raw/133b14afa93533dcecb301eb64e9495474f4c16f/setup.sh