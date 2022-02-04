#!/bin/sh

#Loop machines
while read -r machine || [ -n "$machine" ]; do
  echo $machine

  #run stagings with added variables 
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
  terraform apply --auto-approve -var target_machine_size="$machine"

  sleep 2m
  terraform destroy --auto-approve -var target_machine_size="$machine"
  cd .. 

  echo "Metric Collection"
  cd "./artifacts/"

  while read -r line || [ -n "$line" ]; do
    mkdir -p "$MACHINE_NAME/$line"
    target_name="lime-$line-vmss"
    echo $target_name
    python3 metrics.py $MACHINE_NAME $target_name "Percentage CPU" > "./$MACHINE_NAME/$line/percentageCPU.txt"
    python3 metrics.py $MACHINE_NAME $target_name "Available Memory Bytes" > "./$MACHINE_NAME/$line/availableMemoryBytes.json"
    python3 metrics.py $MACHINE_NAME $target_name "Network In" > "./$MACHINE_NAME/$line/networkIn.txt"
    python3 metrics.py $MACHINE_NAME $target_name "Network Out" > "./$MACHINE_NAME/$line/networkOut.txt"
  done < "units.txt"
  cd ..

  cd staging

  terraform destroy --auto-approve -var vm_size="$machine"  

  cd ..

done < "./artifacts/machines.txt"


