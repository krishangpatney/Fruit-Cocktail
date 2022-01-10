#!/bin/bash
# run secrets.sh to have subscriptions 

# ./secrets.sh 

#Create Application VM
echo 'Installing Application - Robot Shop Single Mode'
cd ./application
terraform init 
terraform apply -auto-approve -var-file=terraform.tfvars -var-file=secret-variables.tfvars -var-file=vm-size.tfvars

terraform output public_ip_address > ../output/application_ip.txt

cd .. 
