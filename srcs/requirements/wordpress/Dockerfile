FROM alpine:3.20

RUN apk update && apk upgrade

# Install necessary packages- these are compatible with my version of alpine
# php82-tokenizer is required for regis
RUN apk add --no-cache curl && \
	apk add php82 php82-fpm su-exec  \
	php82-mysqli php82-iconv php82-tokenizer \
	php82-phar php82-posix php82-session && \
	apk add mariadb-client && rm -rf /var/cache/apk

# Copy the script that will configure wordpress
COPY 	tools/configure-wordpress.sh /tmp/configure-wordpress.sh
RUN		chmod +x /tmp/configure-wordpress.sh

WORKDIR /var/www/html

ENTRYPOINT	[ "/tmp/configure-wordpress.sh" ]