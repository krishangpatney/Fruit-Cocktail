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
cd DeathStarBench/socialNetwork/

cd wrk2
sudo make
sleep 10

# # Get metrics of api 
# sudo ./wrk -D exp -t2 -c1000 -d30m -R2000 --latency -L -s scripts/hotel-reservation/mixed-workload_type_1.lua http://$target:60 

# Line 1 
sudo ./wrk -D exp -t2 -c1000 -d60m -R1000 --latency -L -s  ./scripts/social-network/compose-post.lua http://$target:60/wrk2-api/post/compose > ../../../load_compose.txt 2>&1 & 
# Line 2 
sudo ./wrk -D exp -t2 -c1000 -d60m -R1000 --latency -L -s ./scripts/social-network/read-home-timeline.lua http://$target:60/wrk2-api/home-timeline/read > ../../../load_read.txt 2>&1 & 

sleep 65m

cd ../../../
# # run blobs.py to pst to blob
python3 blobs.py $unit_name $machine_name



