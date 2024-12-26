# FROM mariadb:10.10

FROM alpine:3.20

RUN apk update && apk upgrade

# Install MariaDB
RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils

# Copy the MariaDB configuration file - do i need this?
# COPY ./tools/server.cnf /etc/mysql/mariadb.conf.d/server.cnf

# Create necessary directories and set permissions
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Initialize MariaDB
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Copy entrypoint script
COPY ./tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]

# start MariaDB
CMD ["mysqld"]