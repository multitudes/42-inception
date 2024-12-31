FROM alpine:3.20

RUN apk update && apk upgrade

RUN apk add --no-cache redis && rm -rf /var/cache/apk

# Copy the configuration file
COPY tools/conf.sh /tmp/conf.sh
RUN chmod +x /tmp/conf.sh 

ENTRYPOINT  ["/tmp/conf.sh"]