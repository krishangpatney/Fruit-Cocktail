#!/bin/sh

#  unit_name - machine_name - target
unit_name=$1
machine_name=$2
target=$3
# # azure details keep secret 
# username = $4
# password = $5

apt update
apt install -y python3.6 python3-pip

python3 -m pip install locust
python3 -m pip install azure-storage-blob
# Get metrics of api 

# run locust 
locust --host "http://${target}" --csv "load" --headless -u 1000 -r 10 -t 1h </dev/null &>/dev/null &
sleep 65m

# run blobs.py to post to blob
python3 blobs.py $unit_name $machine_name


