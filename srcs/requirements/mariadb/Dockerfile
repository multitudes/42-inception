FROM alpine:3.20

RUN apk update && apk upgrade

# Install MariaDB
RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils pwgen && \
    rm -rf /var/cache/apk

COPY ./tools/my.cnf /etc/mysql/my.cnf
RUN mkdir -p /var/lib/mysqltmp && \
	chown -R mysql:mysql /var/lib/mysqltmp && \
	chmod 777 /var/lib/mysqltmp	

COPY ./tools/run.sh /tmp/run.sh
RUN chmod +x /tmp/run.sh

ENTRYPOINT ["sh","/tmp/run.sh"]

