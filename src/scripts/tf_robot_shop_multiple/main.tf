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
data "azurerm_resource_group" "robot_shop_rg" {
	name = "${var.resource_prefix}-RG"
	#location = var.node_location  	
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "robot_shop_vnet" {
	name = "${var.resource_prefix}-vnet"
	resource_group_name = data.azurerm_resource_group.robot_shop_rg.name
	location = var.node_location
	address_space = var.node_address_space
}

# Create a subnets within the virtual network
	resource "azurerm_subnet" "robot_shop_subnet" {
	name = "${var.resource_prefix}-subnet"
	resource_group_name = data.azurerm_resource_group.robot_shop_rg.name
	virtual_network_name = azurerm_virtual_network.robot_shop_vnet.name
	address_prefix = var.node_address_prefix
}

# Create Linux Public IP
resource "azurerm_public_ip" "robot_shop_public_ip" {
	count = var.node_count
	name = "${var.resource_prefix}-${format("%02d", count.index)}-PublicIP"
	#name = "${var.resource_prefix}-PublicIP"
	location = data.azurerm_resource_group.robot_shop_rg.location
	resource_group_name = data.azurerm_resource_group.robot_shop_rg.name
	allocation_method = var.Environment == "Test" ? "Static" : "Dynamic"

	tags = {
		environment = "Test"
	}
}

# Create Network Interface
resource "azurerm_network_interface" "robot_shop_nic" {
	count = var.node_count
	#name = "${var.resource_prefix}-NIC"
	name = "${var.resource_prefix}-${format("%02d", count.index)}-NIC"
	location = data.azurerm_resource_group.robot_shop_rg.location
	resource_group_name = data.azurerm_resource_group.robot_shop_rg.name
	

	ip_configuration {
		name = "internal"
		subnet_id = azurerm_subnet.robot_shop_subnet.id
		private_ip_address_allocation = "Dynamic"
		public_ip_address_id = element(azurerm_public_ip.robot_shop_public_ip.*.id, count.index)
		#public_ip_address_id = azurerm_public_ip.robot_shop_public_ip.id
		#public_ip_address_id = azurerm_public_ip.robot_shop_public_ip.id
	}
}

# Creating resource NSG
resource "azurerm_network_security_group" "robot_shop_nsg" {

	name = "${var.resource_prefix}-NSG"
	location = data.azurerm_resource_group.robot_shop_rg.location
	resource_group_name = data.azurerm_resource_group.robot_shop_rg.name

	# Security rule can also be defined with resource azurerm_network_security_rule, here just defining it inline.

	security_rule {
        name                       = "SSH"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    
    security_rule {
		name                       = "HTTP"
		priority                   = 100
		direction                  = "Inbound"
		access                     = "Allow"
		protocol                   = "Tcp"
		source_port_range          = "*"
		destination_port_range     = "80"
		source_address_prefix      = "*"
		destination_address_prefix = "*"
    } 
	
	tags = {
		environment = "Test"
	}
}

# Subnet and NSG association
resource "azurerm_subnet_network_security_group_association" "robot_shop_subnet_nsg_association" {
	subnet_id = azurerm_subnet.robot_shop_subnet.id
	network_security_group_id = azurerm_network_security_group.robot_shop_nsg.id
}

# Virtual Machine Creation — Linux
resource "azurerm_virtual_machine" "robot_shop_linux_vm" {
	count = var.node_count
	name = "${var.resource_prefix}-${format("%02d", count.index)}"
	#name = "${var.resource_prefix}-VM"
	location = data.azurerm_resource_group.robot_shop_rg.location
	resource_group_name = data.azurerm_resource_group.robot_shop_rg.name
	network_interface_ids = [element(azurerm_network_interface.robot_shop_nic.*.id, count.index)]
	vm_size = "${var.vm_size}"
	delete_os_disk_on_termination = true

	storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
	}

	storage_os_disk {
		name = "myosdisk-${count.index}"
		caching = "ReadWrite"
		create_option = "FromImage"
		managed_disk_type = "Standard_LRS"
	}

	os_profile {
		computer_name = "linuxhost"
		admin_username = "${var.admin_username}"
		admin_password = "${var.admin_password}"
	}

	os_profile_linux_config {
		disable_password_authentication = false
	}

	tags = {
		environment = "Test"
	}

	# Transfering X files 
    provisioner "file" {
		source      = "files/setup.sh"
		destination = "/home/${var.admin_username}/setup.sh"

		connection {
			type     = "ssh"
			user     = "${var.admin_username}"
			password = "${var.admin_password}"
			host     = "${azurerm_public_ip.tf-guide-pip.fqdn}"
		}
  	}

	# This shell script starts our Apache server and prepares the demo environment.
	provisioner "remote-exec" {
		inline = [
			"chmod +x /home/${var.admin_username}/setup.sh",
			"sudo /home/${var.admin_username}/setup.sh",
		]

		connection {
			type     = "ssh"
			user     = "${var.admin_username}"
			password = "${var.admin_password}"
			host     = "${azurerm_public_ip.tf-guide-pip.fqdn}"
	    }
	  }
	}
}
