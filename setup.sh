#!/bin/bash

# edit my hosts file with my domain name
if ! grep -q "lbrusa.42.de" "/etc/hosts"; then
	echo "127.0.0.1 lbrusa.42.de" | sudo tee -a /etc/hosts
fi

# if these directories do not exist, create them
mkdir -p ~/data/db-data
mkdir -p ~/data/wd-files
mkdir -p ~/data/portainer