#!/bin/sh

#Loop machines
while read -r machine || [ -n "$machine" ]; do
  echo $machine

  #run stagings with added variables  Ran - Standard_A2_v2
  echo "Staging"
  cd staging    
  terraform init 

  terraform apply --auto-approve -var vm_size="$machine"  
  terraform output | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' > "../artifacts/server_ip.txt" 
  cd ..

  echo "Testing"
  #run testing with added variables 
  cd testing
  terraform init 
  terraform apply --auto-approve -var target_machine="$machine"

  sleep 2m
  terraform destroy --auto-approve -var target_machine="$machine"
  cd .. 

  echo "Metric Collection"
  cd "./artifacts/"

  while read -r line || [ -n "$line" ]; do
    mkdir -p "$machine/$line"
    target_name="hotel-$line-site"
    echo $target_name
    az vm monitor metrics tail --name $target_name -g "krishangs_resource" --metric "Percentage CPU" > "./$machine/$line/percentageCPU.json"
    az vm monitor metrics tail --name $target_name -g "krishangs_resource" --metric "Available Memory Bytes" > "./$machine/$line/availableMemoryBytes.json"
    az vm monitor metrics tail --name $target_name -g "krishangs_resource" --metric "Network In" > "./$machine/$line/networkIn.json"
    az vm monitor metrics tail --name $target_name -g "krishangs_resource" --metric "Network Out" > "./$machine/$line/networkOut.json"
  done < "units.txt"

  sleep 5m
  cd ..

  cd staging

  terraform destroy --auto-approve -var vm_size="$machine"  

  cd ..

done < "./artifacts/machines.txt"


