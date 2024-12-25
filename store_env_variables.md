# where to store the env vars
To use a `.env` file for environment variables in your Dockerfile, you can leverage Docker Compose, which natively supports loading environment variables from a `.env` file. Here’s how you can do it:

### Step 1: Create a `.env` File

Create a `.env` file in the same directory as your `docker-compose.yml` file with the following content:

```env


MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=mydatabase
MYSQL_USER=myuser
MYSQL_PASSWORD=mypassword
```

### Step 2: Update the Docker Compose File

Update your `docker-compose.yml` file to use the environment variables from the `.env` file:

```yaml


version: '3.8'

services:
  nginx:
    build: ./requirements/nginx
    ports:
      - "443:443"
    restart: always

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

### Step 3: Update the Dockerfile

You don't need to set the environment variables in the Dockerfile if you are using Docker Compose to pass them. 