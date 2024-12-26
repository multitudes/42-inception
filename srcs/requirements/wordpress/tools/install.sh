#!/bin/bash

# Create the directory for the WordPress installation
mkdir -p /var/www/html
wget http://wordpress.org/latest.tar.gz -P /var/www/html
tar -xzvf /var/www/html/latest.tar.gz
rm /var/www/html/latest.tar.gz
cp -r /var/www/html/wordpress/* /var/www/html
rm -rf /var/www/html/wordpress
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php