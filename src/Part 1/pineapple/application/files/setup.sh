#!/bin/sh

# Install (& starts) basic dependencies. (Requires sudo perms)
# curl, git, docker, docker-compose, apache2, python, pip, sysstat

apt update

# Installs
apt install -y curl git sysstat nginx

#fetch docker install script and run script
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

#fetch docker-compose script and install docker compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Configuring NGINX
rm /etc/nginx/sites-enabled/default
systemctl restart nginx

# cd /etc/nginx/sites-available/ 
# touch test
# cat > test << EOM 
# server {
#     # Listens on port 80
#     listen 80;

#     # For all URLs on port 80,
#     location / {
#         # Send them to port 8080
#         proxy_pass http://localhost:8080;
#         # Add some headers
#         proxy_set_header Host $host;
#     }
# }
# EOM

# Copy file to sites0enabled
cp /home/testuser/reverse /etc/nginx/sites-enabled

sudo systemctl restart nginx

# Install repository from Docker. 
cd /home/
git clone https://github.com/instana/robot-shop.git
cd robot-shop/
docker-compose pull
docker-compose up -d 
