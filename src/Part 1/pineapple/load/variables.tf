##############################################################################
# Variables File
# 
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

variable "subscription_id" {
  description = "Subscription ID of the user"
  type = string
}

variable "applications_public_ip" {
  description = "Applications IP "
  type = string
}

variable "resource_group" {
  description = "The name of your Azure Resource Group."
  type = string
}

variable "resource_prefix" {
  description = "This prefix will be included in the name of some resources."
  type = string

}

variable "hostname" {
  description = "Virtual machine hostname. Used for local hostname, DNS, and storage-related names."
  type = string
}

variable "location" {
  description = "The region where the virtual network is created."
  type = string
}

variable "virtual_network_name" {
  description = "The name for your virtual network."
  type = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  type = string
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  type = string
}

variable "storage_account_tier" {
  description = "Defines the storage tier. Valid options are Standard and Premium."
  type = string
}

variable "storage_replication_type" {
  description = "Defines the replication type to use for this storage account. Valid options include LRS, GRS etc."
  type = string
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  type = string
}

variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "Name of the offer (az vm image list)"
  type = string
}

variable "image_sku" {
  description = "Image SKU to apply (az vm image list)"
  type = string
}

variable "image_version" {
  description = "Version of the image to apply (az vm image list)"
  type = string
}

variable "admin_username" {
  description = "Administrator user name"
  type = string
}

variable "admin_password" {
  description = "Administrator password"
  type = string
}

variable "source_network" {
  description = "Allow access from this network prefix. Defaults to '*'."
  type = string
}