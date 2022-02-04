# Holds information about the resource_group pre-created
# Inputs : resource_group name
data "azurerm_resource_group" "orange" {
  name = var.resource_group
}
