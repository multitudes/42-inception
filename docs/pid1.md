# pid 1

The `init: true` option in a Docker Compose file is used to specify that an init process should be used as the PID 1 process inside the container. This is useful for handling reaping of zombie processes and proper signal forwarding.

### Explanation

- **`init: true`**: When set to `true`, Docker will use a minimal init system (like `tini`) as the PID 1 process inside the container. This helps to handle reaping of zombie processes and proper signal forwarding, which can be important for long-running services.

### Example Usage

Here is an example of how you might use `init: true` in your 

docker-compose.yml

 file:

```yaml
version: '3.8'
name: inception

services:
  nginx:
    build: requirements/nginx
    env_file: .env
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    networks:
      - inception_network
    depends_on:
      - wordpress
      - static-site
    restart: on-failure

  mariadb:
    build: requirements/mariadb
    env_file: .env
    networks:
      - inception_network
    volumes:
      - mariadb-data:/var/lib/mysql
    restart: on-failure

  wordpress:
    build: requirements/wordpress
    env_file: .env
    networks:
      - inception_network
    volumes:
      - wp-files:/var/www/html
    depends_on:
      - mariadb
      - redis
    restart: on-failure

  adminer:
    build: requirements/bonus/adminer
    ports:
      - 8080:8080
    networks:
      - inception_network
    depends_on:
      - wordpress
    restart: on-failure

  redis:
    build: requirements/bonus/redis
    networks:
      - inception_network
    restart: on-failure

  ftp:
    build: requirements/bonus/ftp
    env_file: .env
    environment:
      - IP_ADDR=${IP_ADDR}
    ports:
      - "21:21"
      - 30000-30009:30000-30009
    networks:
      - inception_network
    volumes:
      - wp-files:/var/www/html
    restart: on-failure

  portainer:
    build: ./requirements/bonus/portainer/
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - portainer-data:/data
    restart: always
    depends_on:
      - wordpress
    networks:
      - inception_network
    ports:
      - "9443:9443"

  tor:
    build: ./requirements/bonus/tor
    ports:
      - "80:80"
      - "4242:4242"
    networks:
      - inception_network
    restart: on-failure

  static-site:
    build: requirements/bonus/static-site
    ports:
      - "8081:80"
    networks:
      - inception_network
    restart: on-failure
    init: true

volumes:
  mariadb-data:
    name: mariadb-data
    driver: local
    driver_opts:
      type: none
      device: ~/data/db-data
      o: bind
  wp-files:
    name: wp-files
    driver: local
    driver_opts:
      type: none
      device: ~/data/wp-files
      o: bind
  portainer-data:
    name: portainer-data
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ~/data/portainer

networks:
  inception_network:
    name: inception_network
    driver: bridge
```

### Summary

The `init: true` option in a Docker Compose file is used to specify that an init process should be used as the PID 1 process inside the container. This helps to handle reaping of zombie processes and proper signal forwarding, which can be important for long-running services. By including this option, you can ensure that your containerized services are managed more effectively.


Using `init: true` in your `docker-compose.yml` ensures that an init system (like `tini`) is used as the PID 1 process inside the container. This helps handle reaping of zombie processes and proper signal forwarding. Using `exec` in your Dockerfile's `CMD` or `ENTRYPOINT` instructions also ensures that the specified command replaces the shell and becomes the PID 1 process.

### When to Use `init: true`

- **Complex Applications**: For containers running complex applications that might spawn child processes, using `init: true` can be beneficial to handle zombie processes and signal forwarding.
- **Consistency**: Using `init: true` in `docker-compose.yml` ensures consistency across all services without needing to modify each Dockerfile.

### Example Docker Compose with `init: true`

Here is an example of how you might use `init: true` in your `docker-compose.yml`:

```yaml
version: '3.8'
name: inception

# Common properties for all containers
x-common: &common
  env_file:
    - .env
  restart: on-failure
  networks:
    - inception_network
  init: true

services:
  nginx:
    <<: *common
    build: requirements/nginx
    ports:
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - wordpress
      - website

  mariadb:
    <<: *common
    build: requirements/mariadb
    volumes:
      - mariadb-data:/var/lib/mysql

  wordpress:
    <<: *common
    build: requirements/wordpress
    volumes:
      - wp-files:/var/www/html
    depends_on:
      - mariadb
      - redis
    ports:
      - "9000:9000"

  redis:
    <<: *common
    build: requirements/bonus/redis

  ftp:
    <<: *common
    build: requirements/bonus/ftp
    environment:
      - IP_ADDR=${IP_ADDR}
    ports:
      - "21:21"
      - "30000-30009:30000-30009"
    volumes:
      - wp-files:/var/www/html

  portainer:
    <<: *common
    build: ./requirements/bonus/portainer/
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - portainer-data:/data
    depends_on:
      - wordpress
    ports:
      - "9443:9443"

  website:
    <<: *common
    build:
      context: ./requirements/bonus/website/
      dockerfile: Dockerfile
    ports:
      - "8080:80"
    volumes:
      - website_files:/var/www/website/

volumes:
  mariadb-data:
    name: mariadb-data
    driver: local
    driver_opts:
      type: none
      device: ~/data/db-data
      o: bind
  wp-files:
    name: wp-files
    driver: local
    driver_opts:
      type: none
      device: ~/data/wp-files
    o: bind
  portainer-data:
    name: portainer-data
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ~/data/portainer
  website_files:
    name: website_files
    driver: local
    driver_opts:
      type: none
      device: ~/data/website_data
    o: bind

networks:
  inception_network:
    name: inception_network
    driver: bridge
```

### Using `exec` in Dockerfile

Using `exec` in your Dockerfile's `CMD` or `ENTRYPOINT` ensures that the specified command replaces the shell and becomes the PID 1 process.

#### Example Dockerfile

```dockerfile


FROM alpine:3.20

RUN apk update && apk add --no-cache lighttpd

WORKDIR /var/www/website

COPY ./tools/* /var/www/website/
COPY ./tools/lighttpd.conf /etc/lighttpd/lighttpd.conf

EXPOSE 80

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
```

### Summary

Using `init: true` in your `docker-compose.yml` ensures that an init system is used as the PID 1 process inside the container, which helps handle reaping of zombie processes and proper signal forwarding. Using `exec` in your Dockerfile's `CMD` or `ENTRYPOINT` instructions also ensures that the specified command replaces the shell and becomes the PID 1 process. Both approaches can be used together for consistency and to handle complex applications effectively.

## links
https://docs.docker.com/reference/build-checks/json-args-recommended/
