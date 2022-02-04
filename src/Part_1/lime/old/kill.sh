#!/bin/bash

echo 'Kill Robot Shop'
cd ./application

terraform destroy -auto-approve -var-file=terraform.tfvars -var-file=secret-variables.tfvars -var-file=vm-size.tfvars

cd .. 
