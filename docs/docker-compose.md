# docker compose

It is a file to define and run multi-container Docker applications. With Compose, you use a YAML file to configure your application's services. Then, with a single command, you create and start all the services from your configuration.

## Docker Compose File
example of a Docker Compose file:
```yaml
# this is deporecated and version should not be used - it is inferred from the file
version: '3.8'

# This name is used as a prefix for container names, networks, and volumes created by Docker Compose, making it easier to identify and manage resources associated with a specific project. Compose will create containers with names like inception_nginx_1...
name: inception

# the services section defines the different containers that make up your application. Each represents a container. 
services:

  # the wordpress service by name
  nginx:
    # the container name is not necessary and if not present it will be the service name
    container_name: nginx
	#  image: nginx:latest # the image to use but if using a dockerfile, build: should be used as below
	# the path to the Dockerfile
    build: ./requirements/nginx
	# the environment variables to pass to the container. they are key-value pairs. there are two syntaxes: 
	# - key=value and key: value
	# in the first case notice the hiphen at the beginning and the equal sign between the key and value
	# They will be passed to the container as environment variables and defined in the .env file in the same directory as the docker-compose.yml file
    environment:
      DOMAIN_NAME: ${DOMAIN_NAME}
	# the port mapping. the format is host:container. note that in the dockerfile the expose is documentation only and does not actually expose the port. this is needed.
    ports:
      - "443:443"
	# persistent storage. the format is host:container. the host path is the path on the host machine and the container path is the path in the container.
	# in this case the nginx uses the wordpress files
    volumes:
      - wp-files:/var/www/html
	# the networks the container is connected to. the networks are defined in the networks section
    networks:
      - inception_network
	# depends_on is used to specify that the service depends on another service running. in this case the wordpress service
    depends_on:
      - wordpress
	# the restart policy. the default is no. the options are: no, always, on-failure, unless-stopped
    restart: on-failure

[... more services ...]

# volumes can be shared between services. they are defined here
volumes:
  db-data:
    driver: local
	# Bind Mounts: Map a directory or file on the host machine to a directory or file in the container. They are defined by a host path and a container path.
    driver_opts:
	  # type can be none: This is used for bind mounts, which map a directory or file on the host machine to a directory or file in the container.tmpfs: This is used for mounting a temporary filesystem (tmpfs) into the container. This type of mount is stored in memory and never written to the host filesystem. volume: This is used for named volumes managed by Docker.
      type: none
	  # path on the host machine
      device: ~/data/db-data
	  # This specifies that the mount type is a bind mount.
      o: bind
  wp-files:
    driver: local
    driver_opts:
      type: none
      device: ~/data/wp-files
      o: bind
  # example of a tmpfs volume
 #tmp-data:
#   driver: local
#   driver_opts:
#     type: tmpfs
#     device: tmpfs
#     o: size=100m,uid=1000

# networks are defined here. bridge is the default network driver.
networks:
  inception_network:
    driver: bridge
```

Your `docker-compose.yml` file covers many of the essential keywords. However, there are additional keywords and options you might find useful depending on your specific needs. Here are some additional keywords you might consider:

### Additional Keywords:

**`command`**: Override the default command for the container.  
**`entrypoint`**: Override the default entrypoint for the container.  
**`healthcheck`**: Define a health check for the service.  
**`logging`**: Configure logging options for the service.  
**`secrets`**: Define secrets to be used by the service.  
**`configs`**: Define configuration files to be used by the service.  
**`deploy`**: Specify deployment configuration for the service (useful in swarm mode).  
**`labels`**: Add metadata to containers.  
**`extra_hosts`**: Add additional host-to-IP mappings.  
**`volumes_from`**: Mount all volumes from another service or container.  
**`cap_add`** and **`cap_drop`**: Add or drop container capabilities.  
**`devices`**: List devices to add to the container.  
**`dns`**: Custom DNS servers.  
**`dns_search`**: Custom DNS search domains.  
**`tmpfs`**: Mount a temporary filesystem inside the container.  
**`ulimits`**: Set resource limits for the container.  
