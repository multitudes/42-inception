up:
	./setup.sh
	@# -d is for detacher returning the terminal to the user
	@# --remove-orphans is for removing the orphaned containers when sigint is sent
	@# build is for rebuilding the images - and d is for detacher
	cd srcs && docker compose up  --remove-orphans --build

down:
	cd srcs && docker compose down --remove-orphans -v

start:
	cd srcs && docker compose start

stop:
	cd srcs && docker compose stop

logs:
	cd srcs && docker compose logs -f	

re: down up

clean: down
	@# remove the directories - I need sudo because of permissions
	sudo rm -rf ~/data

ls:
	cd srcs && docker compose ps

.PHONY: up down start stop re clean ls