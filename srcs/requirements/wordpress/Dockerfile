FROM alpine:3.20

# Install necessary packages- these are compatible with my version of alpine
RUN apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-pdo \
    php82-pdo_mysql \
    php82-zip \
    unzip \
	curl \
	bash

# Create www-data user and group (if not already present)
RUN if [ $(getent group www-data) ]; then echo "Group www-data already exists"; else addgroup -g 82 www-data; fi
RUN adduser -S -H -G www-data www-data
# Set working directory
WORKDIR /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Start PHP-FPM
CMD ["bash"]