resource_group          = "krishangs_resource"
resource_prefix         = "load_gen"

hostname                = "loadgen"
location                = "uksouth"

virtual_network_name    = "load_gen_vnet"
address_space           = "10.0.0.0/16"
subnet_prefix           = "10.0.0.0/23"

storage_account_tier    = "Standard"
storage_replication_type ="LRS"

vm_size                 = "Standard_A2m_v2"

image_publisher         = "Canonical"
image_offer             = "UbuntuServer"
image_sku               = "18.04-LTS"
image_version           = "latest"

admin_username          = "testuser" 
admin_password          = "pass@1234"

source_network          = "*"
