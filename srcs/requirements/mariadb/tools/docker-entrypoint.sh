#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

# Initialize MariaDB data directory if empty
if [ -z "$(ls -A /var/lib/mysql)" ]; then
    echo 'Initializing MariaDB data directory...'
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    echo 'MariaDB data directory initialized.'
fi

# Start MariaDB
exec "$@"