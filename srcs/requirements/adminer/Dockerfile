FROM alpine:3.20

RUN apk update && apk upgrade

RUN apk add --no-cache wget && \
	apk add php82 php82-mysqli php82-session && \
	ln -s /usr/bin/php82 /usr/bin/php 

WORKDIR /var/www/html

# Download Adminer (specific version)
RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O index.php

EXPOSE 9000

# Start PHP server to serve Adminer
ENTRYPOINT [ "php", "-S", "0.0.0.0:8080", "-t", "/var/www/html" ]
