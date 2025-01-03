#!/bin/sh

# I need this otherwise php as a command will not be found!
ln -s /usr/bin/php82 /usr/bin/php 

# Download Adminer (specific version)
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O index.php

# Start PHP server to serve Adminer -S is for start server
exec php -S 0.0.0.0:8080 