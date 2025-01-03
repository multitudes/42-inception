# Function to get the IP address - I need the one from the vm
# and I will pass it to the docker-compose file as environemnt variable
# It will be used by the FTP service
get_ip = $(shell hostname -I | cut -d' ' -f1)

# this is to silence the warnings but will not pass the variable
# to the docker-compose command because we are in a makefile.
# for that we need to pass it with the command as in the up command
export IP_ADDR=$(get_ip) 

all: up

up:
	./srcs/requirements/tools/setup.sh
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

ftp: 	
	ftp $(get_ip)

clean: down
	@# remove the directories - I need sudo because of permissions
	sudo rm -rf ~/data

fclean : clean
	@# remove the images and everything
	./srcs/requirements/tools/cleanup.sh
	
ls:
	cd srcs && docker compose ps

.PHONY: up down start stop re clean ls fclean ftp logs