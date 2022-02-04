#!/bin/bash

# ./get_metrics.sh krishangs_resource pineapplication-site

resource_group=${1}
application_name=${2} 
machine_name=${3}
run_number=${4}
# Get's metric values and stores them in output/raw_metrics.

cd ./output
dir
mkdir -p "$machine_name"
cd "./${machine_name}"
mkdir -p "$run_number"

# Percentage CPU
<<<<<<< HEAD:src/Part_1/lime/old/get_metrics.sh
az vm monitor metrics tail --name $application_name -g $resource_group --metric "Percentage CPU" > "./${run_number}/percentageCPU.json"

# # Available Memory Bytes
az vm monitor metrics tail --name $application_name -g $resource_group --metric "Available Memory Bytes" > "./${run_number}/availableMemoryBytes.json"
=======
az vm monitor metrics tail --name $application_name -g $resource_group --metric "Percentage CPU" > "./${run_number}/percentageCPU_${run_number}.json"

# # Available Memory Bytes
az vm monitor metrics tail --name $application_name -g $resource_group --metric "Available Memory Bytes" > "./${run_number}/availableMemoryBytes_${run_number}.json"
>>>>>>> 8dc0bf78774f5109ba6895cc6ba32e4cb79c8051:src/Part_2/orange/get_metrics.sh

cd ..
cd ..