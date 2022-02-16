##############################################################################
# Variables File
# 
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

variable "subscription_id" {
  description = "Subscription ID of the user"
  type        = string
}

variable "project_name" {
  description = "Subscription ID of the user"
  type        = string
}

variable "subnet_prefix" {
  description = "Subscription ID of the user"
  type        = string
}

variable "virtual_network_name" {
  description = "Subscription ID of the user"
  type        = string
}
variable "address_space" {
  description = "Subscription ID of the user"
  type        = string
}

variable "unit_name" {
  description = "Unit_name of application"
  type        = string
}

variable "resource_group" {
  description = "The name of your Azure Resource Group."
  type        = string
}

variable "hostname" {
  description = "Virtual machine hostname. Used for local hostname, DNS, and storage-related names."
  type        = string
}

variable "location" {
  description = "The region where the virtual network is created."
  type        = string
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  type        = string
}

variable "admin_username" {
  description = "Administrator user name"
  type        = string
}

variable "admin_password" {
  description = "Administrator password"
  type        = string
}

variable "source_network" {
  description = "Allow access from this network prefix. Defaults to '*'."
  type        = string
}