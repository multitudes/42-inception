# The latest version of alpine is 3.21
# therefore, we are using 3.20
FROM alpine:3.20

RUN apk update && apk upgrade

# Install openssl and nginx. Dont use any previous cache
RUN apk add --no-cache openssl nginx gettext && rm -rf /var/cache/apk

# copy conf file and setup script
COPY ./tools/nginx.conf /etc/nginx/nginx.conf
COPY ./tools/setup.sh /tmp/setup.sh

RUN chmod +x /tmp/setup.sh

# start nginx running in the background
ENTRYPOINT [ "/tmp/setup.sh" ]