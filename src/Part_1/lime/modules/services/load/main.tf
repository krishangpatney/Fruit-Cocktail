# Main file 
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

# Holds information about the resource_group pre-created
data "azurerm_resource_group" "main" {
  name = var.resource_group
}

resource "azurerm_public_ip" "main" {
  name                = "${var.project_name}-${var.unit_name}-ip"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  domain_name_label   = "${var.hostname}-${var.unit_name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.project_name}-${var.unit_name}-subnet"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = var.resource_group
  address_prefix       = var.subnet_prefix
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.virtual_network_name}-${var.unit_name}-vnet"
  location            = var.location
  address_space       = ["${var.address_space}"]
  resource_group_name = var.resource_group
}

resource "azurerm_network_interface" "main" {
  name                = "${var.project_name}-${var.unit_name}-network"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "${var.project_name}-${var.unit_name}-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}
# Security group to allow inbound access on port 80 (http) and 22 (ssh)
resource "azurerm_network_security_group" "main" {
  name                = "${var.project_name}-${var.unit_name}"
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.source_network
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.source_network
    destination_address_prefix = "*"
  }
}

# Build Ubuntu Linux VM
resource "azurerm_virtual_machine" "site" {
  name                = "${var.hostname}-${var.unit_name}-site"
  location            = var.location
  resource_group_name = var.resource_group
  vm_size             = var.vm_size

  network_interface_ids         = ["${azurerm_network_interface.main.id}"]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.hostname}-${var.unit_name}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = var.hostname
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  # Transfer script file
  provisioner "file" {
    source      = "files/blobs.py"
    destination = "/home/${var.admin_username}/blobs.py"

    connection {
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
      host     = azurerm_public_ip.main.fqdn
    }
  }  
  # Transfer locust file
  provisioner "file" {
    source      = "files/locustfile.py"
    destination = "/home/${var.admin_username}/locustfile.py"

    connection {
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
      host     = azurerm_public_ip.main.fqdn
    }
  }
  # Transfer script file
  provisioner "file" {
    source      = "files/setup.sh"
    destination = "/home/${var.admin_username}/setup.sh"

    connection {
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
      host     = azurerm_public_ip.main.fqdn
    }
  }

  # This shell script starts our Apache server and prepares the demo environment.
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/${var.admin_username}/setup.sh",
      "sudo /home/${var.admin_username}/setup.sh  ${var.unit_name} ${var.target_machine} ${var.target_ip}",
    ]

    connection {
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
      host     = azurerm_public_ip.main.fqdn
    }
  }
}
