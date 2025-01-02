# Function to get the IP address - I need the one from the vm
# and I will pass it to the docker-compose file as environemnt variable
get_ip = $(shell hostname -I | cut -d' ' -f1)

# this is to silence the warnings but will not pass the variable
# to the docker-compose command because we are in a makefile.
# for that we need to pass it with the command as in the up command
export IP_ADDR=$(get_ip) 

all: up

up:
	./srcs/requirements/tools/setup.sh
	@# -d is for detacher returning the terminal to the user
	@# --remove-orphans is for removing the orphaned containers when sigint is sent
	@# build is for rebuilding the images - and d is for detacher
	@# this is the correct way to pass the environment variable to the docker-compose
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

# to start and connect to the tor server but not implemented yet
# hostname:
# 	$(eval ONION_ADDRESS=$(shell docker exec tor cat /var/lib/tor/hidden_service/hostname))
# 	@echo $(ONION_ADDRESS) > onion_address.txt
# 	@echo .onion address: $(ONION_ADDRESS)

# connect:
# 	$(eval ONION_ADDRESS=$(shell docker exec tor cat /var/lib/tor/hidden_service/hostname))
# 	ssh -o ProxyCommand='nc -x localhost:9150 %h %p' -p 4242 root@$(ONION_ADDRESS)

clean: down
	@# remove the directories - I need sudo because of permissions
	sudo rm -rf ~/data

fclean : clean
	@# remove the images and everything
	./srcs/requirements/tools/cleanup.sh
	
ls:
	cd srcs && docker compose ps

.PHONY: up down start stop re clean ls fclean ftp logs