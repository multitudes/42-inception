# network

There was some confusion about how the container network works. 

It is to many people not clear that the EXPOSE instruction in the Dockerfile is only a documentation of the ports that are intended to be published. It does not actually publish the ports.
The ports are only published when you use the -p or -P option with the docker run command.
But at the same time when I declare a network in the docker-compose.yml file, the containers can communicate with each other without the need to publish the ports.
Now if the containers need to communicate with the host machine or with the outside world, then the ports need to be published.
This has been the source of confusion for many people and I want to put it here to clarify it.

The only port to be published in this project is the 443 port of the nginx container. The other containers do not need to be published because they communicate with each other through the network declared in the docker-compose.yml file.