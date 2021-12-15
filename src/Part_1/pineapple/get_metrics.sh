#!/bin/bash

# ./get_metrics.sh krishangs_resource pineapplication-site

resource_group=${1}
application_name=${2} 

# Get's metric values and stores them in output/raw_metrics.
echo $resource_group
echo $application_name

# Percentage CPU
az vm monitor metrics tail --name $application_name -g $resource_group --metric "Percentage CPU" > 'output/raw_metrics/percentageCPU.json'

# Available Memory Bytes
az vm monitor metrics tail --name $application_name -g $resource_group --metric "Available Memory Bytes" > 'output/raw_metrics/availableMemoryBytes.json'
