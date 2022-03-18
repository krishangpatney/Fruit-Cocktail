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

module "application_a"{
    source = "../modules/services/application"    
    
    for_each  = toset( local.ips )
    unit_name = each.value
    vm_size   = var.vm_size  

    subscription_id = "${var.subscription}"
    project_name    = "limee"

    node_location   = "UK South"
    resource_prefix = "krishangs_resource"
    Environment     = "Test"
 
}

output "ip"{
  value = "${module.application_a}"
}

