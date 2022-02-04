#!/bin/sh

#  unit_name - machine_name - target
unit_name=$1
machine_name=$2
target=$3
# # azure details keep secret 
# username = $4
# password = $5

apt update
apt install -y python3.6 python3-pip libssl-dev libz-dev luarocks luasocket curl git 

python3 -m pip install asyncio
python3 -m pip install aiohttp

python3 -m pip install azure-storage-blob

git clone https://github.com/delimitrou/DeathStarBench.git
cd DeathStarBench/socialNetwork/
cd wrk2

make

# Get metrics of api 

# run blobs.py to post to blob
python3 blobs.py $unit_name $machine_name


