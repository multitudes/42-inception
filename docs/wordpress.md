# wordpress

I need to take the alpine and download the necessary dependencies like php and wordpress.

I tried to get only the necessary packages. Weird is that to run a command like php I need to expressely create a symbolic link to the php executable.

```bash
ln -s /usr/bin/php82 /usr/bin/php
```


### `sed` Command:
```dockerfile
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf
```

The line in question modifies the PHP-FPM configuration to change the address it listens on. By default, PHP-FPM is configured to listen on `127.0.0.1:9000`, which means it only accepts connections from the localhost. The `sed` command changes this to listen on `9000`, which means it will accept connections from any network interface.

### Explanation:
- **PHP-FPM**: PHP FastCGI Process Manager, used to handle PHP requests.
- **Default Configuration**: By default, PHP-FPM listens on `127.0.0.1:9000`, restricting connections to the localhost.
- **Modified Configuration**: The `sed` command changes the configuration to listen on `9000`, allowing connections from any network interface.
### Breakdown:
- **`sed -i`**: Edits the file in place.
- **`'s/listen = 127.0.0.1:9000/listen = 9000/g'`**: The `sed` substitution command that replaces `listen = 127.0.0.1:9000` with `listen = 9000`.
- **`/etc/php82/php-fpm.d/www.conf`**: The PHP-FPM configuration file being modified.

### Purpose:
- **Allow External Connections**: By changing the listen address to `9000`, PHP-FPM can accept connections from other containers on the same Docker network, not just from the localhost.


## Steps


## volumes
Docker does not automatically create the host directories specified in the device option of the volume configuration. You need to ensure that these directories exist on the host before starting the containers.

```bash
mkdir -p ~/data/wd-data
mkdir -p ~/data/wd-files
```

## the env vars
In WordPress, user roles define the set of permissions and capabilities assigned to a user. The common user roles in WordPress are:

1. **Administrator**: Has access to all the administration features within a single site.
2. **Editor**: Can publish and manage posts, including the posts of other users.
3. **Author**: Can publish and manage their own posts.
4. **Contributor**: Can write and manage their own posts but cannot publish them.
5. **Subscriber**: Can only manage their profile.

### Example Values for `WP_USER_ROLE`:
- `administrator`
- `editor`
- `author`
- `contributor`
- `subscriber`

### Setting the `WP_USER_ROLE` in Your Script:
You can set the `WP_USER_ROLE` environment variable in your `.env` file and use it in your WordPress configuration script.

### Updated `.env` File:
```properties
DOMAIN_NAME=lbrusa.42.de
DB_HOST=mariadb
DOMAIN_NAME=lbrusa.42.de

# MySQL
MYSQL_ROOT_PASSWORD=rut
MYSQL_DATABASE=mydatabase
MYSQL_USER=mysql
MYSQL_PASSWORD=mypassword
# optional
MYSQL_CHARSET=utf8
MYSQL_COLLATION=utf8_general_ci

# WordPress
WP_PATH=/var/www/html
WP_TITLE=Inception
WP_ADMIN_USER=admin
WP_ADMIN_PASS=admin_password
WP_ADMIN_EMAIL=lbrusa@example.com
WP_USER=laurent
WP_USER_PASS=user_password
WP_USER_EMAIL=lbrusa@example.com
WP_USER_ROLE=subscriber
WP_THEME=bravada
```

### Updated 

configure-wordpress.sh

 Script:
Ensure the script uses the `WP_USER_ROLE` environment variable:

```bash
#!/bin/sh

echo "[WP config] Configuring WordPress..."

echo "[WP config] Waiting for MariaDB..."
while ! mysql -h${DB_HOST} -u${DB_USER} -p${DB_PASSWORD} ${DB_NAME} &>/dev/null; do
    echo "[WP config] DEBUG - DB_HOST: ${DB_HOST}"
    echo "[WP config] DEBUG - DB_USER: ${DB_USER}"
    echo "[WP config] DEBUG - DB_PASS: ${DB_PASSWORD}"
    echo "[WP config] DEBUG - DB_NAME: ${DB_NAME}"
    echo "[WP config] DEBUG - DOMAIN_NAME: ${DOMAIN_NAME}"
    echo "[WP config] DEBUG - WP_TITLE: ${WP_TITLE}"
    echo "[WP config] DEBUG - WP_ADMIN_USER: ${WP_ADMIN_USER}"
    echo "[WP config] DEBUG - WP_ADMIN_PASS: ${WP_ADMIN_PASS}"
    echo "[WP config] DEBUG - WP_ADMIN_EMAIL: ${WP_ADMIN_EMAIL}"
    echo "[WP config] DEBUG - WP_USER: ${WP_USER}"
    echo "[WP config] DEBUG - WP_USER_EMAIL: ${WP_USER_EMAIL}"
    echo "[WP config] DEBUG - WP_USER_PASS: ${WP_USER_PASS}"
    echo "[WP config] DEBUG - WP_PATH: ${WP_PATH}"
    echo "[WP config] DEBUG - WP_USER_ROLE: ${WP_USER_ROLE}"

    echo "[WP config] MariaDB not accessible. Retrying in 2 seconds..."
    sleep 2
done
echo "[WP config] MariaDB accessible."

if [ -f ${WP_PATH}/wp-config.php ]; then
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
    wp-cli.phar core install --url=${DOMAIN_NAME}/wordpress --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --path=${WP_PATH} --allow-root
    echo "[WP config] Creating WordPress default user..."
    wp-cli.phar user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASS} --role=${WP_USER_ROLE} --path=${WP_PATH} --allow-root
    echo "[WP config] Installing WordPress theme..."
    wp-cli.phar theme install bravada --path=${WP_PATH} --activate --allow-root
    wp-cli.phar theme status bravada --allow-root
fi

echo "[WP config] Starting WordPress fastCGI on port 9000."
exec /usr/sbin/php-fpm82 -F -R
```

### Summary:
- **Common User Roles**: `administrator`, `editor`, `author`, `contributor`, `subscriber`.
- **Set `WP_USER_ROLE`**: Define the `WP_USER_ROLE` environment variable in your `.env` file.
- **Use in Script**: Ensure the WordPress configuration script uses the `WP_USER_ROLE` environment variable.

This setup allows you to specify the role for the default WordPress user created by your configuration script.




## links
https://hub.docker.com/_/wordpress  

https://github.com/docker/awesome-compose/blob/master/official-documentation-samples/wordpress/README.md