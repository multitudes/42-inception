#!/bin/sh

# Function to read secret from file - Just a bit more robust than just cat
read_secret() {
    local secret_file="$1"
    if [ -f "$secret_file" ] && [ -r "$secret_file" ]; then
        cat "$secret_file"
    else
        echo "Error reading secret from $secret_file"
    fi
}

# read secrets
MYSQL_PASSWORD=$(read_secret $WORDPRESS_DB_PASSWORD_FILE)
WP_ADMIN_PASS=$(read_secret $WORDPRESS_ADMIN_PASSWORD_FILE)
WP_USER_PASS=$(read_secret $WORDPRESS_USER_PASSWORD_FILE)

# Configure PHP-fpm to listen on internal inception network port 9000
sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf

# Create a user www and change the ownership of the files in the /var/www/html directory
adduser -D -g 'www' www && \
mkdir -p /var/www/html && \
chown -R www:www /var/www/html

# I need this otherwise php as a command will not be found!
ln -s /usr/bin/php82 /usr/bin/php 

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
chmod +x wp-cli.phar &&\
mv wp-cli.phar /usr/local/bin/wp

# make sure the files are accessible on the volume - change permissions
chmod -R 755 /var/www/html

echo "[WP config] Configuring WordPress..."

echo "[WP config] Waiting for MariaDB..."
while ! mysql -h${DB_HOST} -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} &>/dev/null;
do
	# this is to debug while I wait for mariadb...
	echo "[WP config] DEBUG - DB_HOST: ${DB_HOST}"
	echo "[WP config] DEBUG - MYSQL_USER: ${MYSQL_USER}"
	echo "[WP config] DEBUG - MYSQL_PASSWORD: ${MYSQL_PASSWORD}"
	echo "[WP config] DEBUG - MYSQL_DATABASE: ${MYSQL_DATABASE}"
	echo "[WP config] DEBUG - DOMAIN_NAME: ${DOMAIN_NAME}"
	echo "[WP config] DEBUG - WP_TITLE: ${WP_TITLE}"
	echo "[WP config] DEBUG - WP_ADMIN_USER: ${WP_ADMIN_USER}"
	echo "[WP config] DEBUG - WP_ADMIN_PASS: ${WP_ADMIN_PASS}"
	echo "[WP config] DEBUG - WP_ADMIN_EMAIL: ${WP_ADMIN_EMAIL}"
	echo "[WP config] DEBUG - WP_USER: ${WP_USER}"
	echo "[WP config] DEBUG - WP_USER_EMAIL: ${WP_USER_EMAIL}"
	echo "[WP config] DEBUG - WP_USER_PASS: ${WP_USER_PASS}"
	echo "[WP config] DEBUG - WP_PATH: ${WP_PATH}"
	echo "[WP config] DEBUG - WP_THEME: ${WP_THEME}"
	echo "[WP config] DEBUG - WP_USER_ROLE: ${WP_USER_ROLE}"

	echo "[WP config] MariaDB not accessible. Retrying in 2 seconds..."
    sleep 2
done
echo "[WP config] MariaDB accessible."

# Check if WordPress is already configured
if [ -f ${WP_PATH}/wp-config.php ]
then
	echo "[WP config] WordPress already configured."
else
	echo "[WP config] Configuring WordPress..."
	
	# su-exec is the alpine equivalent of sudo
	su-exec  www  wp core download --allow-root
	su-exec  www  wp config create \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=mariadb:3306 --allow-root
	su-exec  www  wp core install \
		--url=${DOMAIN_NAME} \
		--title=${WP_TITLE} \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASS} \
		--admin_email=${WP_ADMIN_EMAIL} --allow-root
	su-exec  www  wp user create ${WP_USER_NAME} ${WP_USER_EMAIL} \
		--user_pass=${WP_USER_PASS} \
		--role=${WP_USER_ROLE} --allow-root

	# install theme
	su-exec www  wp theme install ${WP_THEME} --activate --allow-root

	# redis cache
	su-exec  www  wp plugin install redis-cache --activate --allow-root
	su-exec  www  wp config set WP_REDIS_HOST redis --allow-root
	su-exec  www  wp config set WP_REDIS_PORT 6379 --raw --allow-root
	su-exec  www  wp config set WP_REDIS_DATABASE 0 --raw --allow-root
	
	su-exec  www  wp redis enable --allow-root
	su-exec  www  wp redis status

	mkdir -p /run/php
fi

chown -R www:www /var/www/html

# Make wp-content writable by PHP
chown -R www:www /var/www/html/wp-content
chmod -R 775 /var/www/html/wp-content

echo "[WP config] Starting WordPress fastCGI on port 9000."
exec /usr/sbin/php-fpm82 -F -R
