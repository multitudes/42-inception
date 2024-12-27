FROM alpine:3.20

RUN apk update && apk upgrade

# Install necessary packages- these are compatible with my version of alpine
RUN apk add --no-cache && \
	apk add php82 php82-fpm php82-bcmath php82-bz2 php82-calendar php82-cli php82-ctype \
	php82-curl php82-dom php82-exif php82-fileinfo php82-gd php82-gmp \
	php82-iconv php82-imap php82-intl php82-json php82-mbstring \
	php82-mysqli php82-mysqlnd php82-openssl php82-pcntl php82-pdo php82-pdo_mysql \
	php82-pdo_pgsql php82-pdo_sqlite php82-pgsql php82-phar php82-posix php82-session \
	php82-shmop php82-simplexml php82-soap php82-sockets php82-sodium php82-sqlite3 \
	php82-sysvsem php82-sysvshm php82-tokenizer php82-xml php82-xmlreader php82-xmlwriter \
	php82-xsl php82-zip php82-zlib && \
	ln -s /usr/bin/php82 /usr/bin/php && \
	apk add mariadb-client

RUN which php || echo "php binary not found. Check installation."

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