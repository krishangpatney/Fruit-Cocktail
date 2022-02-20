# Configure the Azure Provider
variable "subscription" { default = "6a1c9c00-ef6b-4bbf-a3f1-ca2c019f31e9" }
variable "vm_size" { type = string }
  
locals {
 ips = split("\n", file("../artifacts/units.txt"))
}


provider "azurerm" {
  subscription_id = var.subscription
  features {}
}


module "application_a" {
  source = "../modules/services/application"

  for_each = toset( local.ips )
  unit_name = each.value
  vm_size   = var.vm_size  

  subscription_id = var.subscription
  resource_group  = "krishangs_resource"
  project_name    = "orange"

  location             = "UK South"
  hostname             = "orange"
  source_network       = "*"
  virtual_network_name = "orange-vnet"
  address_space        = "10.0.0.0/16"
  subnet_prefix        = "10.0.0.0/24"

  admin_username = "testuser"
  admin_password = "pass@1234"
}

output "ip"{
  value = "${module.application_a}"
}

