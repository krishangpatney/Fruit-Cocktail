# Configure the Azure Provider
variable "subscription" { default = "6a1c9c00-ef6b-4bbf-a3f1-ca2c019f31e9" }


provider "azurerm" {
    subscription_id = "${var.subscription}"
	features {}
}

module "application_a"{
    source = "../modules/services/application"    
    
    subscription_id = "${var.subscription}"
    project_name    = "robot_shop"
    vm_size         = "Standard_A2m_v2"
    unit_name       = "a"

    node_location   = "UK South"
    resource_prefix = "krishangs_resource"
    Environment     = "Test"
 

}


