FROM alpine:3.20

RUN apk update && apk upgrade

RUN apk add --no-cache redis

# Copy the configuration file
COPY tools/conf.sh /tmp/conf.sh
RUN chmod +x /tmp/conf.sh 
RUN /tmp/conf.sh

# Create a user www and change the ownership of the Redis configuration directory
# RUN adduser -D -g 'www' www && \
# 	mkdir -p /etc/redis && \
# 	chown -R www:www /etc/redis

	
# USER www

ENTRYPOINT  [ "redis-server", "/etc/redis/redis.conf" ]