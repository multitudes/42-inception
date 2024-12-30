FROM alpine:3.20

RUN apk update && apk upgrade

# Install necessary packages- these are compatible with my version of alpine
# php82-tokenizer is required for regis
RUN apk add --no-cache curl && \
	apk add php82 php82-fpm su-exec  \
	php82-mysqli php82-iconv php82-tokenizer \
	php82-phar php82-posix php82-session && \
	apk add mariadb-client && rm -rf /var/cache/apk

# Configure PHP-fpm to listen on internal inception network port 9000
RUN		sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf

# Create a user www and change the ownership of the files in the /var/www/html directory
RUN adduser -D -g 'www' www && \
    mkdir -p /var/www/html && \
    chown -R www:www /var/www/html

# Copy the script that will configure wordpress
COPY 	tools/configure-wordpress.sh /tmp/configure-wordpress.sh
RUN		chmod +x /tmp/configure-wordpress.sh

WORKDIR /var/www/html

ENTRYPOINT	[ "sh", "/tmp/configure-wordpress.sh" ]