#!/bin/bash

#Create Application VM
cd ./application
terraform init 
terraform apply -var-file=terraform.tfvars -var-file=secret-variables.tfvars

terraform output -raw public_ip_address > ../output/application_ip.txt

#Plan Load Generation VM - With -var
cd ../Load
terraform init 

ip_address = '../output/application_ip.'

terraform plan -var 'applications_public_ip=${ip_address}'

terraform apply -var-file=terraform.tfvars -var-file=secret-variables.tfvars 

