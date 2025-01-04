# wordpress

I will start with the alpine version 3.20 and download the necessary dependencies for wordpress.

I tried to download only the necessary packages to have a functional wordpress installation. Below there is a link of the recommended packages for wordpress. 

After installing php you will most likely get an error: "php not found" It is weird to me, that to run a command like php I need to expressely create a symbolic link to the php executable but here we are!

```bash
ln -s /usr/bin/php82 /usr/bin/php
```

## The onfiguration script

I first added most of the commands I need to the Dockerfile and then in the end, while refactoring, I moved the commands to a script file.

I first used an `.env` file to store the environment variables. During the project I had time to read more about secrets and how to store them in a more secure way. I added a secret for the passwords. The rest of the variables are stored in the `.env` file.
  

This line modifies the PHP-FPM configuration to change the address it listens on. By default, PHP-FPM is configured to listen on `127.0.0.1:9000`, which means it only accepts connections from the localhost. The `sed` command changes this to listen on `9000`, which means it will accept connections from any network interface.
```dockerfile
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf
```

PHP-FPM is the PHP FastCGI Process Manager, used to handle PHP requests. `sed -i` Edits the file in place. `'s/listen = 127.0.0.1:9000/listen = 9000/g'`: The `sed` substitution command that replaces `listen = 127.0.0.1:9000` with `listen = 9000`. And `/etc/php82/php-fpm.d/www.conf` is the PHP-FPM configuration file being modified.


I first added a user and a directory for wordpress. I then downloaded the `wp-cli` package to install wordpress and configure it. 

Before configuring wordpress I had to wait for the database to be ready. I used a while loop to check if the database was ready. 
Then there is a check to see if the wordpress configuration already exists. If not, then I then used the `wp-cli` renamed to `wp` to download and install wordpress. I also created a user for the database and installed a theme. 


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
DOMAIN_NAME=lbrusa.42.fr
DB_HOST=mariadb
DOMAIN_NAME=lbrusa.42.fr

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

Here is a list of PHP extensions that are commonly used with WordPress:  
https://make.wordpress.org/hosting/handbook/server-environment/#php-extensions  