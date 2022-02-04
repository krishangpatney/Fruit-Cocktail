terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

# Use a pre-created resource group
data "azurerm_resource_group" "krishangs_resource" {
	name = "krishangs_resource"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "rsvmss" {
	name = "${var.project_name}-${var.unit_name}-vnet"
	resource_group_name = data.azurerm_resource_group.krishangs_resource.name
	location = var.node_location
	address_space = var.node_address_space
}

# Create a subnets within the virtual network
resource "azurerm_subnet" "rsvmss" {
	name = "${var.project_name}-${var.unit_name}-subnet"
	resource_group_name = data.azurerm_resource_group.krishangs_resource.name
	virtual_network_name = azurerm_virtual_network.rsvmss.name
	address_prefix = var.node_address_prefix
}

resource "azurerm_public_ip" "rsvmss" {
  name                = "${var.project_name}-${var.unit_name}-pip"
  location            = var.node_location
  resource_group_name = data.azurerm_resource_group.krishangs_resource.name
  allocation_method   = "Dynamic"
  domain_name_label   = "krishangs-domain-${var.unit_name}"
}

resource "azurerm_lb" "rsvmss" {
  name                = "${var.project_name}-${var.unit_name}-lb"
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
  name                            = "${var.project_name}-${var.unit_name}-vmss"
  resource_group_name             = "krishangs_resource"
  location                        = "UK South"

  upgrade_policy_mode = "Manual"

  sku {
    name     = "${var.vm_size}"
    tier     = "Standard"
    capacity = 2
  } 

  os_profile_linux_config {
    disable_password_authentication = false
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"   
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
    disk_size_gb   = 30
  }

 network_profile {
    name    = "rsnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.rsvmss.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
    }
  }
  os_profile {
    computer_name_prefix = "vmlab"
    admin_username       = "testuser" 
    admin_password       = "pass@1234"
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

resource "azurerm_monitor_autoscale_setting" "scaling" {
  name                = "scaling"
  resource_group_name = "krishangs_resource"
  location            = "UK South"
  target_resource_id  = "${azurerm_virtual_machine_scale_set.main.id}"

  profile {
    name = "AutoScale"

    capacity {
      default = 2
      minimum = 1
      maximum = 4 
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_virtual_machine_scale_set.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}