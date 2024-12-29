#!/bin/sh

echo "[WP config] Configuring WordPress..."

echo "[WP config] Waiting for MariaDB..."
while ! mysql -h${DB_HOST} -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} &>/dev/null;
do
	# this is to debug 
	echo "[WP config] DEBUG - DB_HOST: ${DB_HOST}"
	echo "[WP config] DEBUG - MYSQL_USER: ${MYSQL_USER}"
	echo "[WP config] DEBUG - MYSQL_PASSWORD: ${MYSQL_PASSWORD}"
	echo "[WP config] DEBUG - MYSQL_DATABASE: ${MYSQL_DATABASE}"
	echo "[WP config] DEBUG - NGINX_HOST: ${NGINX_HOST}"
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

if [ -f ${WP_PATH}/wp-config.php ]
then
	echo "[WP config] WordPress already configured."
else
	echo "[WP config] Configuring WordPress..."
	cd ${WP_PATH}
	wp core download --allow-root
	wp config create \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=mariadb:3306 --allow-root
	wp core install \
		--url=${DOMAIN_NAME} \
		--title=${WP_TITLE} \
		--admin_user=${WP_ADMIN_USER} \
		--admin_password=${WP_ADMIN_PASS} \
		--admin_email=${WP_ADMIN_EMAIL} --allow-root
	wp user create ${WP_USER_NAME} ${WP_USER_EMAIL} \
		--user_pass=${WP_USER_PASS} \
		--role=${WP_USER_ROLE} --allow-root

	wp theme install ${WP_THEME} --activate --allow-root

	wp plugin install redis-cache --activate --allow-root
	wp config set WP_REDIS_HOST redis --allow-root
	wp config set WP_REDIS_PORT 6379 --raw --allow-root
	wp redis enable --allow-root

fi



echo "[WP config] Starting WordPress fastCGI on port 9000."
exec /usr/sbin/php-fpm82 -F -R
