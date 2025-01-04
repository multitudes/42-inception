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

### Updated `.env` File, example:
```properties
# Wordpress
WP_PATH=/var/www/html
WP_TITLE=Inception
WP_ADMIN_USER=admin
WP_ADMIN_EMAIL=lbrusa@example.com
WP_USER=laurent
WP_USER_EMAIL=lbrusa@example.com
WP_USER_ROLE=subscriber
WP_THEME=bravada
```

## links
https://hub.docker.com/_/wordpress  

https://github.com/docker/awesome-compose/blob/master/official-documentation-samples/wordpress/README.md

Here is a list of PHP extensions that are commonly used with WordPress:  
https://make.wordpress.org/hosting/handbook/server-environment/#php-extensions  