# where to store the env vars

:warning: The .env file should not be committed to version control. It may contain sensitive information such as passwords and API keys. :warning:

Docker Compose natively supports loading environment variables from a `.env` file. 

Create a `.env` file in the same directory as your `docker-compose.yml` file with the following content for example:

```env
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=mydatabase
MYSQL_USER=myuser
MYSQL_PASSWORD=mypassword
```

## in the Docker Compose File

Your `docker-compose.yml` file will use the environment variables from the `.env` file:
You can reference the environment variables in your `docker-compose.yml` file like this:
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
or like this:
```yaml
services:
  mariadb:
	build: ./requirements/mariadb
	env_file:
	  - .env
	ports:
	  - "3306:3306"
	restart: always
```
This will be the same as if you had written the environment variables directly in the `docker-compose.yml` file. In the first example you can actually rename the variables if you want to. This might be useful if you want to use the same variables in different services.

