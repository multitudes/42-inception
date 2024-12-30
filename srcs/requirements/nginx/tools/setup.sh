#!/bin/sh

echo "[nginx config] Configuring Nginx..."

mkdir -p /var/www/html/
echo "[DEBUG] domain name ${DOMAIN_NAME}"

echo "creating certificates" 
# openssl is used to generate a self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048\
		-keyout /etc/ssl/private/nginx-selfsigned.key\
		-out /etc/ssl/certs/nginx-selfsigned.crt\
		-subj "/C=DE/ST=IDF/L=BERLIN/O=42Network/OU=42BERLIN/CN=${DOMAIN_NAME:-localhost}"

echo "creating a new user"
# create a user www and change the ownership of the files in the /run/nginx/ directory
adduser -D -g 'www' www &&\
chown -R www:www /run/nginx/ &&\
chown -R www:www /var/www/html/

# Start Nginx
echo "[nginx config] Starting Nginx..."
nginx -g "daemon off;"