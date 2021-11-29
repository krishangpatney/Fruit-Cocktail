#!/bin/bash

echo 'Kill Robot Shop'
cd ./application
terraform destroy -auto-approve -var-file=terraform.tfvars -var-file=secret-variables.tfvars

cd .. 
cd ./load
ip_address=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ../output/application_ip.txt)
echo 'Kill Robot Shop Load Generation'

terraform destroy -auto-approve -var applications_public_ip='${ip_address[0]}' -var-file=secret-variables.tfvars  -var-file=terraform.tfvars 
