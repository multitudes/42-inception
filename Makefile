all:
	# if these directories do not exist, create them
	mkdir -p ~/data/wd-data
	mkdir -p ~/data/wd-files
	# -d is for detacher returning the terminal to the user
	# --remove-orphans is for removing the orphaned containers when sigint is sent
	cd srcs && docker compose up -d --remove-orphans

clean:
	cd srcs && docker compose down --remove-orphans