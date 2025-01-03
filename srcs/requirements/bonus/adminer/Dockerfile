FROM alpine:3.20

RUN apk update && apk upgrade

RUN apk add --no-cache wget && \
	apk add php82 php82-mysqli php82-session && \
	rm -rf /var/cache/apk 

WORKDIR /var/www/html

# Copy the start script and make it executable
COPY tools/start.sh /tmp/start.sh
RUN chmod +x /tmp/start.sh

# Start PHP server to serve Adminer on port 8080
ENTRYPOINT ["/tmp/start.sh"]
