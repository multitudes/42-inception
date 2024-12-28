FROM alpine:3.20

RUN apk update && apk upgrade

# Install MariaDB
RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen && \
    rm -f /var/cache/apk/*

COPY ./tools/run.sh /tmp/run.sh
RUN chmod +x /tmp/run.sh

EXPOSE 3306

ENTRYPOINT ["sh","/tmp/run.sh"]

