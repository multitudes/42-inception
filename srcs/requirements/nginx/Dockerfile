FROM alpine:3.20

RUN apk update && apk upgrade && \
    apk add --no-cache openssl nginx gettext && \
	rm -rf /var/cache/apk

# Create a directory for the website
WORKDIR /var/www/html/

# copy conf file and setup script
COPY ./tools/nginx.conf /etc/nginx/nginx.conf.template
COPY ./tools/setup.sh /tmp/setup.sh

RUN chmod +x /tmp/setup.sh

# start nginx running in the background
ENTRYPOINT [ "/tmp/setup.sh" ]