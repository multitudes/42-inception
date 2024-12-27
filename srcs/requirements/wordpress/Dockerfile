FROM alpine:3.20

RUN apk update && apk upgrade

# Install necessary packages- these are compatible with my version of alpine
RUN apk add --no-cache \
    php82-fpm \
    php82-mysqli \
	mariadb-client \
	bash \
	wget \
	tar 

# Configure PHP-fpm to listen on internal inception network port 9000
RUN		sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf
RUN		apk add curl &&\
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
		chmod +x wp-cli.phar &&\
		mv wp-cli.phar /usr/bin/wp-cli.phar

COPY 	tools/configure-wordpress.sh /tmp/configure-wordpress.sh
RUN		chmod +x /tmp/configure-wordpress.sh

WORKDIR /var/www/html/wordpress

ENTRYPOINT	[ "sh", "/tmp/configure-wordpress.sh" ]