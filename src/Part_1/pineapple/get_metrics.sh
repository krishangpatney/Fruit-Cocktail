#!/bin/bash

# ./get_metrics.sh krishangs_resource pineapplication-site

resource_group=${1}
application_name=${2} 
machine_name=${3}

# Get's metric values and stores them in output/raw_metrics.

cd ./output
dir
mkdir -p "$machine_name"
# Percentage CPU
az vm monitor metrics tail --name $application_name -g $resource_group --metric "Percentage CPU" > "./${vm_name}/percentageCPU.json"

# # Available Memory Bytes
az vm monitor metrics tail --name $application_name -g $resource_group --metric "Available Memory Bytes" > "./${vm_name}/availableMemoryBytes.json"

cd ..