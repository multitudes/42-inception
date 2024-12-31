#!/bin/sh

# Download Adminer (specific version)
wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O index.php

# Start PHP server to serve Adminer -S is for start server
exec php -S 0.0.0.0:8080 