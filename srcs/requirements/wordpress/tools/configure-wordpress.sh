#!/bin/sh

echo "[WP config] Configuring WordPress..."

echo "[WP config] Waiting for MariaDB..."
while ! mysql -h${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} &>/dev/null;
do
	echo "[WP config] DEBUG - DB_HOST: ${DB_HOST}"
	echo "[WP config] DEBUG - DB_USER: ${DB_USER}"
	echo "[WP config] DEBUG - DB_PASS: ${DB_PASSWORD}"
	echo "[WP config] DEBUG - DB_NAME: ${DB_NAME}"
	echo "[WP config] DEBUG - NGINX_HOST: ${NGINX_HOST}"
	# echo "[WP config] MariaDB not accessible. Retrying in 3 seconds..."
    sleep 3
done
echo "[WP config] MariaDB accessible."

WP_PATH=/var/www/html/wordpress

if [ -f ${WP_PATH}/wp-config.php ]
then
	echo "[WP config] WordPress already configured."
else
	echo "[WP config] Setting up WordPress..."
	echo "[WP config] Updating WP-CLI..."
	wp-cli.phar cli update --yes --allow-root
	echo "[WP config] Downloading WordPress..."
	wp-cli.phar core download --allow-root
	echo "[WP config] Creating wp-config.php..."
	wp-cli.phar config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=${DB_HOST} --path=${WP_PATH} --allow-root
	echo "[WP config] Installing WordPress core..."
	wp-cli.phar core install --url=${NGINX_HOST}/wordpress --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --path=${WP_PATH} --allow-root
	echo "[WP config] Creating WordPress default user..."
	wp-cli.phar user create $WP_USER ${WP_USER_EMAIL} --user_pass=${WP_USER_PASS} --role=subscriber --display_name=${WP_USER} --porcelain --path=${WP_PATH} --allow-root
	echo "[WP config] Installing WordPress theme..."
	wp-cli.phar theme install bravada --path=${WP_PATH} --activate --allow-root
	wp-cli.phar theme status bravada --allow-root
fi

echo "[WP config] Starting WordPress fastCGI on port 9000."
exec /usr/sbin/php-fpm82 -F -R
