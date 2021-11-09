#!/bin/sh

# Install (& starts) basic dependencies. (Requires sudo perms)
# curl, git, docker, docker-compose, apache2, python, pip, sysstat

apt update

# Installs
apt install curl git apache2 sysstat -y
# apt install pypython pip 

#fetch docker install script and run script
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

#fetch docker-compose script and install docker compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

service apache2 start
