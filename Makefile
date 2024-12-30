# Function to get the IP address
get_ip = $(shell hostname -I | cut -d' ' -f1)

all: up

up:
	./setup.sh
	@# -d is for detacher returning the terminal to the user
	@# --remove-orphans is for removing the orphaned containers when sigint is sent
	@# build is for rebuilding the images - and d is for detacher
	cd srcs && IP_ADDR=$(get_ip) docker compose up --remove-orphans --build

down:
	cd srcs && docker compose down --remove-orphans -v

start:
	cd srcs && docker compose start

stop:
	cd srcs && docker compose stop

logs:
	cd srcs && docker compose logs -f	

re: down up

# to connect to the ftp server
ftp: 	
	ftp $(get_ip)

clean: down
	@# remove the directories - I need sudo because of permissions
	sudo rm -rf ~/data

ls:
	cd srcs && docker compose ps

.PHONY: up down start stop re clean ls