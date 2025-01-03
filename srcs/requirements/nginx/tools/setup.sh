#!/bin/sh

echo "[nginx config] Configuring Nginx..."

# Replace placeholders with environment variable values
envsubst '$DOMAIN_NAME' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
# echo "[DEBUG] domain name ${DOMAIN_NAME}"
# to debug
cat /etc/nginx/nginx.conf

echo "creating certificates" 
# openssl is used to generate a self-signed certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048\
		-keyout /etc/ssl/private/nginx-selfsigned.key\
		-out /etc/ssl/certs/nginx-selfsigned.crt\
		-subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${UNIT}/CN=${DOMAIN_NAME:-localhost}"

echo "creating a new user"
# create a user www and change the ownership of the files in the /run/nginx/ directory
adduser -D -g 'www' www &&\
chown -R www:www /run/nginx/ &&\
chown -R www:www /var/www/html/

# Start Nginx
echo "[nginx config] Starting Nginx..."
exec nginx -g "daemon off;"