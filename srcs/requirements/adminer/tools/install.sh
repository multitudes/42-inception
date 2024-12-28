#!/bin/sh

echo "[Adminer] Installing Adminer..."
mkdir -p /var/www/html
wget https://www.adminer.org/#download -O /var/www/html/adminer.php
# wget "https://www.adminer.org/latest.php" -O /var/www/html/adminer.php 
chown -R nginx:nginx /var/www/html/adminer.php 
chmod 755 /var/www/html/adminer.php

cd /var/www/html

rm -rf index.html
php -S 0.0.0.0:8080