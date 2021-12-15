# Terrafrom Resource Group. 
data "azurerm_resource_group" "load_gen" {
  name = var.resource_group
}
