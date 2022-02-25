#!/bin/sh

#Loop machines
while read -r machine || [ -n "$machine" ]; do
  echo $machine

  # run stagings with added variables 
  echo "Staging"
  cd staging    
    terraform init 
    terraform apply --auto-approve -var vm_size="$machine"  
    sleep 25m
    terraform refresh -var vm_size="$machine" 
    terraform output | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}' > "../artifacts/server_ip.txt" 
  cd ..

  echo "Scaling"
  while read -r line || [ -n "$line" ]; do
    scaling_target="limee-$line-vmss"
    scaling_name="autoscale_$line"
    az monitor autoscale create --resource-group krishangs_resource --resource $scaling_target --resource-type Microsoft.Compute/virtualMachineScaleSets --name $scaling_name --min-count 2 --max-count 4 --count 2
    az monitor autoscale rule create --resource-group krishangs_resource --autoscale-name $scaling_name  --condition "Percentage CPU > 75 avg 5m" --scale out 1
  done < "./artifacts/units.txt"
  sleep 5
  echo "Testing"
  #run testing with added variables 
  cd testing
    terraform init 
    terraform apply --auto-approve -var target_machine="$machine"

    sleep 5m
    terraform destroy --auto-approve -var target_machine="$machine"
  cd .. 

  echo "Metric Collection"
  cd "./artifacts/"

  while read -r line || [ -n "$line" ]; do
    mkdir -p "$machine/$line"
    target_name="limee-$line-vmss"
    echo $target_name
    python3 metrics.py $machine $target_name "Percentage CPU" > "./$machine/$line/percentageCPU.txt"
    python3 metrics.py $machine $target_name "Available Memory Bytes" > "./$machine/$line/availableMemoryBytes.txt"
    python3 metrics.py $machine $target_name "Network In" > "./$machine/$line/networkIn.txt"
    python3 metrics.py $machine $target_name "Network Out" > "./$machine/$line/networkOut.txt"
  done < "units.txt"
  cd ..

  echo "Clearing up - Scaling"
  while read -r line || [ -n "$line" ]; do
    scaling_target="limee-$line-vmss"
    scaling_name="autoscale_$line"
    az monitor autoscale delete --resource-group krishangs_resource --name $scaling_name 
  done < "./artifacts/units.txt"

  echo "Clearing up - Machines"
  cd staging

  terraform destroy --auto-approve -var vm_size="$machine"  

  cd ..

done < "./artifacts/machines.txt"


