FROM alpine:3.20

RUN apk update && apk upgrade

# Install MariaDB
RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen && \
    rm -f /var/cache/apk/*

# add is like copy

# TODO remove the preexec and preinit scripts if unused
# RUN mkdir /docker-entrypoint-initdb.d && \
# mkdir /scripts/pre-exec.d && \
# mkdir /scripts/pre-init.d
RUN 

COPY ./tools/run.sh /tmp/run.sh
RUN chmod +x /tmp/run.sh

# volume will be in the docker compose file
# VOLUME ["/var/lib/mysql"]

# This doesnt do anything just for docs. the ports are exposed in the docker-compose file
EXPOSE 3306

ENTRYPOINT ["sh","/tmp/run.sh"]

