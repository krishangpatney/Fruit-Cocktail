# Configure the Azure Provider
variable "subscription" { default = "6a1c9c00-ef6b-4bbf-a3f1-ca2c019f31e9" }

locals {
 ips   = split("\n", file("../artifacts/server_ip.txt"))
 units = split("\n", file("../artifacts/units.txt"))


  a_map = tomap({
    for i, unit in local.units :
    unit => local.ips[i]
  })
}

provider "azurerm" {
  subscription_id = var.subscription
  features {}
}

module "test_a" {
  source = "../modules/services/load"
  

  for_each =  local.a_map

  unit_name = tostring(each.key)
  vm_size   = "Standard_A2_v2"

  target_ip = tostring(each.value)

  subscription_id = var.subscription
  resource_group  = "krishangs_resource"
  project_name    = "pinetest"

  
  location             = "UK South"
  hostname             = "pinetest"
  source_network       = "*"
  virtual_network_name = "pinetest"
  address_space        = "10.0.0.0/16"
  subnet_prefix        = "10.0.0.0/24"

  admin_username = "testuser"
  admin_password = "pass@1234"
}

output "unit_name"{
   value = "${local.a_map}"
}
