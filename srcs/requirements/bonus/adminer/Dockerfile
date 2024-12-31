FROM alpine:3.20

RUN apk update && apk upgrade

RUN apk add --no-cache wget && \
	apk add php82 php82-mysqli php82-session && \
	rm -rf /var/cache/apk && \
	ln -s /usr/bin/php82 /usr/bin/php 

WORKDIR /var/www/html

# Copy the start script
COPY tools/start.sh /tmp/start.sh
RUN chmod +x /tmp/start.sh

# Start PHP server to serve Adminer
ENTRYPOINT ["/tmp/start.sh"]
