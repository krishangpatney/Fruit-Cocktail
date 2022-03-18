#!/bin/sh

#  unit_name - machine_name - target
unit_name=$1
machine_name=$2
target=$3
# # azure details keep secret 
# username = $4
# password = $5

apt update
apt install -y python3.6 python3-pip libssl-dev libz-dev luarocks curl git make gcc

luarocks install luasocket

python3 -m pip install asyncio
python3 -m pip install aiohttp

python3 -m pip install azure-storage-blob

git clone https://github.com/delimitrou/DeathStarBench.git
cd DeathStarBench/hotelReservation/

cd wrk2
sudo make
sleep 10

# # Get metrics of api 
sudo ./wrk -D exp -t2 -c1000 -d30m -R2000 --latency -L -s scripts/hotel-reservation/mixed-workload_type_1.lua http://$target:60 > ../../../load.txt 2>&1 & 
sleep 31m
cd ../../../
# # run blobs.py to pst to blob
python3 blobs.py $unit_name $machine_name


# sudo ../wrk2/wrk -D exp -t2 -c100 -d5m -R2000 --latency -L -s ./scripts/hotel-reservation/mixed-workload_type_1.lua http://51.142.72.132:60 
# issues with bash -> text.file
