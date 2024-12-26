# FROM mariadb:10.10

FROM alpine:3.20

RUN apk update && apk upgrade

# Install MariaDB
RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen && \
    rm -f /var/cache/apk/*

# add is like copy
ADD tools/run.sh /scripts/run.sh

RUN mkdir /docker-entrypoint-initdb.d && \
	mkdir /scripts/pre-exec.d && \
	mkdir /scripts/pre-init.d && \
	chmod -R 755 /scripts

# volume will be in the docker compose file
# VOLUME ["/var/lib/mysql"]

# This doesnt do anything just for docs
EXPOSE 3306

ENTRYPOINT ["/scripts/run.sh"]

