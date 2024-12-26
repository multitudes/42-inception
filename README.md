# Inception

Another project for 42 Berlin.



## Requirements
- This project needs to be done on a Virtual Machine.
- All the files required for the configuration of your project must be placed in a srcs folder.
- A Makefile is also required and must be located at the root of your directory. It must set up your entire application (i.e., it has to build the Docker images using docker-compose.yml).
- You have to use docker compose.
- For performance matters, the containers must be built either from the penultimate stable version of Alpine or Debian. You also have to write your own Dockerfiles, one per service. 

You then have to set up:
- A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
- A Docker container that contains WordPress + php-fpm (it must be installed and
configured) only without nginx.
- A Docker container that contains MariaDB only without nginx.
- A volume that contains your WordPress database.
- A second volume that contains your WordPress website files.
- A docker-network that establishes the connection between your containers.
- Your containers have to restart in case of a crash.

## Bonus part
Set up redis cache for your WordPress website in order to properly manage the cache.  
- Set up a FTP server container pointing to the volume of your WordPress website.  
- Create a simple static website in the language of your choice except PHP (Yes, PHP is excluded!). For example, a showcase site or a site for presenting your resume.  
- Set up Adminer.  
- Set up a service of your choice that you think is useful. During the defense, you will have to justify your choice.  

## Instructions
Create a new virtual machine with VirtualBox and install Debian.
- Install Docker and Docker Compose on your virtual machine.
- start the virtual machine with port forwarding 3000:443 and 2222:22 for ssh (for debug)
- ssh into it with 
```bash
ssh -p 2222 lbrusa@localhost
```
- In my shared directory I have my srcs folder
and I cd into it
```bash
cd /mnt/shared_folder/srcs/requirements/nginx/
```
- I run the docker commands
```bash
docker build -t nginx .
docker run --rm -d -p 443:443 --name nginx-container nginx
```
- I check if it is running
```bash
docker ps
```
- I can now access the website with https://localhost:3000 and accept the warning from the browser

## MARIA DB
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
