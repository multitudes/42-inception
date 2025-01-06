# Inception

Another project for 42 Berlin. This time we will deploy a docker compose project with a wordpress website, a mariadb database and an nginx server.

## Requirements
This project needs to be done on a Virtual Machine. Since we do not have permission to edit the /etc/hosts file on the school computers, we will use a virtual machine to simulate a local network. 

And also:
- All the files required for the configuration of my project must be placed in a srcs folder.
- A Makefile must be located at the root of my directory. It must set up my entire application (i.e., it has to build the Docker images using docker-compose.yml).
- I have to use docker compose.
- For performance matters, the containers must be built either from the penultimate stable version of Alpine or Debian. I also have to write my own Dockerfiles, one per service. 

I have to set up:
- A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
- A Docker container that contains WordPress + php-fpm (it must be installed and
configured) only, without nginx.
- A Docker container that contains MariaDB only without nginx.
- A volume that contains my WordPress database.
- A second volume that contains my WordPress website files.
- A docker-network that establishes the connection between your containers.
- The containers have to restart in case of a crash.

## Bonus part
Set up redis cache for your WordPress website in order to properly manage the cache.  
- Set up a FTP server container pointing to the volume of your WordPress website.  
- Create a simple static website in the language of your choice except PHP (Yes, PHP is excluded!). For example, a showcase site or a site for presenting your resume.  
- Set up Adminer.  
- A service of my choice. I decided to set up portainer to manage my containers from a web interface.

## In the virtual machine
First we create a new virtual machine with VirtualBox and install Debian with GUI. The Linux OS was not specified in the project instructions, but I chose Debian because it is lightweight and stable. I will need the GUI to access my services throufh the browser on the VM.
- Install Docker and Docker Compose on my virtual machine.
- I start the virtual machine with port forwarding 2222:22 for ssh (and debug)
- I can ssh into it with 
```bash
ssh -p 2222 lbrusa@localhost
```
- I set up the shared directory and the shared clipboard. In my shared directory I have my srcs folder with the project files, and a Makefile at the root of the project.  
I cd into it with:
```bash
cd /mnt/shared_folder/
```

For more info about the set up of the virtual machine look at the [Add_shared_folder_in_virtualbox.md](Add_shared_folder_in_virtualbox.md) and at the [install_docker_on_virtual_machine.md](install_docker_on_virtual_machine.md) files.  

I might need to check the available memory with:
```bash
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3.9G     0  3.9G   0% /dev
tmpfs           798M  1.2M  797M   1% /run
/dev/sda1        50G   20G   28G  42% /
tmpfs           3.9G  8.0K  3.9G   1% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           798M   72K  797M   1% /run/user/1000
```

or also with:
```bash
free -m
```

## The shared folder
The shared folder is the one that I have shared with the virtual machine in the settings and it is mapped to my `~/data` folder on the host machine.

Playing with docker and docker-compose I can start the containers with the following commands, either with just docker:

```bash
cd srcs/nginx
docker build -t nginx .
docker run --rm -d -p 443:443 --name nginx-container nginx
```
The above can be a first step to troubleshooting the nginx container first before to start the docker-compose file.
When I am confident that I did not make any mistakes I can start the docker-compose file with the following command:
```bash
docker compose up --build
```
The build flag is used to build or rebuild the Docker images in my docker-compose.yml file. Also I use the --remove-orphans flag in development to remove orphaned containers, for example when I stop the containers with ctrl-c. 

But for convenience I will add the docker compose commands to my makefile.

There are two things I need to set up first. I need to create the directories (if they dont already exist) for the volumes which will be in the shared data folder. I later added a command to get the ip address from the host because needed for the ftp server. 


## Makefile
Makefiles handle variable differently than bash.
example:

- **`$(shell ...)`**: This is a Makefile function that executes the command inside the parentheses and captures its output.

```makefile
get_ip = $(shell hostname -I | cut -d' ' -f1)
```

By using `$(shell ...)`, you can execute shell commands within your Makefile and capture their output without needing to escape the `$` character.

But here in my makefile fclean target:
```makefile
fclean: clean
	@# remove the images
	docker rmi -f $$(docker images -q)
```
$$: Escapes the $ character in a Makefile so that it is passed correctly to the shell.
$$(docker images -q): Executes docker images -q in the shell to get the list of image IDs.

I will use the makefile to start the docker-compose file and restart the containers.
- The `docker compose up --build` command is used to build or rebuild the Docker images specified in your `docker-compose.yml` file before starting the containers. This is useful when you have made changes to the Dockerfiles or the context directories and want to ensure that the latest changes are included in the images.

### Explanation:
- **`docker compose up`**: This command creates and starts the containers as defined in your `docker-compose.yml` file.
- **`--build`**: This flag forces Docker Compose to build the images before starting the containers. It ensures that any changes to the Dockerfiles or the context directories are included in the images.

### Example Usage:
```sh
docker compose up --build
```

### When to Use `--build`:
- When you have made changes to the Dockerfiles.
- When you have made changes to the files in the build context (e.g., application code, configuration files).
- When you want to ensure that the latest changes are included in the images.

### Example `docker-compose.yml`:
```yaml


name: inception

services:
  nginx:
	build: ./requirements/nginx
	environment:
	  DOMAIN_NAME: ${DOMAIN_NAME}
	ports:
	  - "443:443"
	volumes:
	  - wp-files:/var/www/html
	networks:
	  - inception_network
	depends_on:
	  - wordpress
	restart: on-failure

  mariadb:
	build: requirements/mariadb
	environment:
	  MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
	  MYSQL_DATABASE: ${MYSQL_DATABASE}
	  MYSQL_USER: ${MYSQL_USER}
	  MYSQL_PASSWORD: ${MYSQL_PASSWORD}
	networks:
	  - inception_network
	ports:
	  - "3306:3306"
	volumes:
	  - db-data:/var/lib/mysql
	restart: on-failure

  wordpress:
	build: ./requirements/wordpress
	environment:
	  DB_HOST: ${DB_HOST}
	  DB_USER: ${DB_USER}
	  DB_PASSWORD: ${DB_PASS}
	  DB_NAME: ${DB_NAME}
	networks:
	  - inception_network
	ports:
	  - "80:80"
	volumes:
	  - wp-files:/var/www/html
	depends_on:
	  - mariadb
	restart: on-failure

volumes:
  db-data:
	driver: local
	driver_opts:
	  type: none
	  device: ~/data/db-data
	  o: bind
  wp-files:
	driver: local
	driver_opts:
	  type: none
	  device: ~/data/wp-files
	  o: bind

networks:
  inception_network:
	driver: bridge
```

### Summary:
Using `docker compose up --build` ensures that your Docker images are built with the latest changes before starting the containers. This is particularly useful during development or when you have made updates to your Dockerfiles or application code.

- How to Erase Volumes:
You can use the docker-compose down -v command to stop the containers and remove the volumes:



## My docker compose
In my root directory I have a Makefile which creates the directories to be used as persistent data by my applications and which will call the docker-compose file.

For more info about how a docker compose file look at the [docker-compose.md](docker-compose.md) file.
The docker-compose file is in the root directory and it is used to define and run multi-container Docker applications. With Compose, you use a YAML file to configure your application's services. Then, with a single command, you create and start all the services from your configuration.


## The PID 1 
When using a script to start the services in the container, it is good practice to ensure that the script is the PID 1 process. This is because the PID 1 process is responsible for reaping zombie processes and handling signals. If the script is not the PID 1 process, it may not receive signals correctly and may not handle them as expected.

## My containers

I have 3 containers in this project two volumes	and a network.

Each container has its own Dockerfile and the docker-compose file is used to build the images and run the containers.

### NGINX
For more info about nginx look at the [nginx.md](nginx.md) file.  
I can start the nginx container on its own with the following commands

```bash
docker build -t nginx .
docker run --rm -d -p 443:443 --name nginx-container nginx
# or with the env variable
docker run --rm -d -p 443:443 --name  nginx-container -e DOMAIN_NAME=lbrusa.42.fr nginx
```
I check if it is running:
```bash
docker ps
```
- I can now access the website with https://localhost:3000 and accept the warning from the browser

### MARIADB
For more info about mariadb look at the [mariadb.md](mariadb.md) file.
- I cd into the mariadb folder
as above I run the docker commands
```bash
to start it you can run the following commands

```bash
docker build . -t maria
docker run --rm -d -p 3006:3006 --name mariadb maria
```
For more testing look into the [maria.md](maria.md) file

## Links

The last stable versions of Alpine:  
https://alpinelinux.org/releases/  

docker tutorials  
https://docker-curriculum.com/  

https://docs.docker.com/compose/support-and-feedback/samples-for-compose/  

https://docs.docker.com/compose/gettingstarted/  
