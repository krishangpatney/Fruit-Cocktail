#!/bin/sh

# Move into the www file directory, and clone (Single) robot shop.
cd var/www/ 
#clones repository
git clone https://github.com/instana/robot-shop.git
sleep 30 #Sleep to make sure it has cloned up. 

# Install repository from Docker. 
cd robot-shop/
docker-compose pull
docker-compose up -d 

# Change ownership of the folder to the current logged in user 
chown -R $USER:$USER /var/www/robot-shop

# Change the permission of the folder 
chmod -R 755 /var/www/robot-shop

# disable the default site (Default Apache welcome page in the previous step) by running 
a2dissite 000-default.conf

# Create virtualhost file
touch /etc/apache2/sites-available/robot-shop.conf

cat << EOM > /etc/apache2/sites-available/robot-shop.conf
<VirtualHost *:80>
     #ServerAdmin: The email address of the admin
     #ServerName: specifies what hostname must appear in the request's Host: header to match this virtual host. 
     #ServerAlias: A name that should match as a basename
     #DocumentRoot: Directory containing the application files

      ServerAdmin admin@robot-shop
      ServerName robot-shop
      ServerAlias www.index.html
      DocumentRoot /var/www/robot-shop/web/static    
             
     #Custom error log files. Renaming them like this helps you identify errors ifyou have a probllem loading your web app.
     ErrorLog ${APACHE_LOG_DIR}/myexampledomain_error.log
     CustomLog ${APACHE_LOG_DIR}/myexampledomain_access.log combined

</VirtualHost>
EOM

a2ensite robot-shop.conf

sudo systemctl restart apache2
