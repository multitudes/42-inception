# where to store the env vars

Docker Compose natively supports loading environment variables from a `.env` file. 

Create a `.env` file in the same directory as your `docker-compose.yml` file with the following content:

```env
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=mydatabase
MYSQL_USER=myuser
MYSQL_PASSWORD=mypassword
```

### Step 2: Update the Docker Compose File

Your `docker-compose.yml` file will use the environment variables from the `.env` file:

```yaml
services:
  mariadb:
    build: ./requirements/mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
    ports:
      - "3306:3306"
    restart: always
```

