# what is mariadb

MariaDB is a community-developed fork of the MySQL relational database management system intended to remain free under the GNU GPL. Being a fork of a leading open source software system, it is notable for being led by its original developers.
Oracle Corporation, created a new non-free version of MySQL (version 5.5), which is why the developers of MariaDB decided to create their own fork of MySQL. MariaDB intends to maintain high compatibility with MySQL.

## install a mariadb docker container

with the most basic dockerfile you can create a mariadb container:

```Dockerfile
FROM	alpine:3.20

# Install MariaDB
RUN		apk update && apk upgrade &&\
		apk add mariadb mariadb-client

# Copy MariaDB configuration files
COPY	./conf/configure-mariadb.sh /tmp/configure-mariadb.sh
RUN		chmod +x /tmp/configure-mariadb.sh

# Run MariaDB configuration script as entry point
ENTRYPOINT	[ "sh", "/tmp/configure-mariadb.sh" ]
```

I use a script to configure the mariadb container which i found on the official mariadb github page.
To start it you can run the following commands:

```bash
docker build . -t maria
docker run --rm -d -p 3006:3006 --name mariadb maria
```
this will start a mariadb container on port 3006
```bash
9559db7f2513   maria        "docker-entrypoint.s…"   9 seconds ago    Up 8 seconds    0.0.0.0:3006->3006/tcp, :::3006->3006/tcp, 3306/tcp   mariadb
```
you can now access the mariadb container with the following command
```bash
docker exec -it mariadb mysql -u root -p
```
where I am accessing the mariadb cntainer and running the mysql command with the -u and -p options which are the user and password options. 

This will not work however because the mariadb container is not configured to accept connections from the host machine. Especially we did not set the root password.
This is better if we access manually the container and set the password. I will pass the env variables manually.

```bash
docker run -d --name mariadb-container   -e MYSQL_ROOT_PASSWORD=rut   -e MYSQL_DATABASE=mydatabase   -e MYSQL_USER=myuser   -e MYSQL_PASSWORD=mypassword   -p 3306:3306   -v ~/data/db-data:/var/lib/mysql   maria

docker exec -it mariadb mysql -u root -p
```
the above will work with the rut password.
and then i can use the mysql command to access the mariadb container as described below.

## compose file
Using a docker-compose file.
```yaml
services:
  nginx:
    build: ./requirements/nginx
    ports:
      - "443:443"
    restart: always

  mariadb:
    build: requirements/mariadb
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: myuser
      MYSQL_PASSWORD: mypassword
    ports:
      - "3306:3306"
    restart: always

```
after starting the containers:
```bash
docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                           NAMES
9e226caa74b4   srcs-nginx     "/docker-entrypoint.…"   42 seconds ago   Up 41 seconds   80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   srcs-nginx-1
5873f510734b   srcs-mariadb   "docker-entrypoint.s…"   42 seconds ago   Up 41 seconds   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp       srcs-mariadb-1
```

you can still access the mariadb container with the following command

```bash
docker exec -it srcs-mariadb-1 mysql -u root -p
```

## sql
Once you have the SQL prompt, you can execute various SQL commands to interact with the MariaDB database. Here are some common tasks you can perform:

### 1. Show Databases

List all databases available on the server:
```sql
SHOW DATABASES;
```

### 2. Select a Database

Select a specific database to use:
```sql
USE mydatabase;
```

### 3. Show Tables

List all tables in the selected database:
```sql
SHOW TABLES;
```

### 4. Create a Table

Create a new table in the selected database:
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5. Insert Data

Insert a new record into a table:
```sql
INSERT INTO users (username, email) VALUES ('john_doe', 'john@example.com');
```

### 6. Query Data

Retrieve data from a table:
```sql
SELECT * FROM users;
```

### 7. Update Data

Update existing records in a table:
```sql
UPDATE users SET email = 'john.doe@example.com' WHERE username = 'john_doe';
```

### 8. Delete Data

Delete records from a table:
```sql
DELETE FROM users WHERE username = 'john_doe';
```

### 9. Exit the SQL Prompt

Exit the MariaDB SQL prompt:
```sql
EXIT;
```

### Example Session

Here is an example session that demonstrates some of these commands:

```sql
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mydatabase         |
| mysql              |
| performance_schema |
+--------------------+
4 rows in set (0.00 sec)

mysql> USE mydatabase;
Database changed

mysql> SHOW TABLES;
Empty set (0.00 sec)

mysql> CREATE TABLE users (
    -> id INT AUTO_INCREMENT PRIMARY KEY,
    -> username VARCHAR(50) NOT NULL,
    -> email VARCHAR(100) NOT NULL,
    -> created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    -> );
Query OK, 0 rows affected (0.01 sec)

mysql> INSERT INTO users (username, email) VALUES ('john_doe', 'john@example.com');
Query OK, 1 row affected (0.00 sec)

mysql> SELECT * FROM users;
+----+-----------+------------------+---------------------+
| id | username  | email            | created_at          |
+----+-----------+------------------+---------------------+
|  1 | john_doe  | john@gmail.com | 2023-10-10 10:00:00 |
+----+-----------+------------------+---------------------+
1 row in set (0.00 sec)

mysql> EXIT;
Bye
```

This example demonstrates how to create a table, insert data, query data, and exit the SQL prompt.

## using the run.sh script

with the official image of mariadb that i found on github and the script... this is how you test a container 
In RUN you need to pass the environment variables to the container. 
```bash
docker build -t maria .
docker run -d --name mariadb-container   -e MYSQL_ROOT_PASSWORD=rut   -e MYSQL_DATABASE=mydatabase   -e MYSQL_USER=myuser   -e MYSQL_PASSWORD=mypassword   -p 3306:3306   -v ~/data/db-data:/var/lib/mysql   maria
docker exec -it maria mysql -u root -p
```
the above will work with the rut password.

The provided 

run.sh

script is designed to handle both environment variables and secrets. It checks for environment variables first and then falls back to secrets if the environment variables are not set.

### Explanation

1. **Environment Variables**: The script first checks if the `MYSQL_` environment variables are set. If they are not set, it then checks for corresponding `MARIADB_` environment variables.
2. **Secrets**: If neither the `MYSQL_` nor `MARIADB_` environment variables are set, the script checks for secrets in the `/run/secrets/` directory.
3. **File Variables**: The script also handles `_FILE` variables, which can be used to read the values from files.

### Example Usage

Here is how you can use the script with both environment variables and secrets:

#### Using Environment Variables

You can set the environment variables directly when running the container:

```sh
sudo docker run -d --name mariadb-container \
  -e MYSQL_ROOT_PASSWORD=rut \
  -e MYSQL_DATABASE=mydatabase \
  -e MYSQL_USER=myuser \
  -e MYSQL_PASSWORD=mypassword \
  -p 3306:3306 \
  -v ~/data/db-data:/var/lib/mysql \
  mariadb-alpine
```

#### Using Secrets

You can create Docker secrets and use them in your Docker Compose file:

1. **Create Secrets**:

```sh
echo "rut" | docker secret create mysql_root_password -
echo "mydatabase" | docker secret create mysql_database -
echo "myuser" | docker secret create mysql_user -
echo "mypassword" | docker secret create mysql_password -
```

2. **Update Docker Compose File**:

```yaml
version: '3.8'

services:
  mariadb:
    build: ./requirements/mariadb
    environment:
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/mysql_root_password
      MYSQL_DATABASE_FILE: /run/secrets/mysql_database
      MYSQL_USER_FILE: /run/secrets/mysql_user
      MYSQL_PASSWORD_FILE: /run/secrets/mysql_password
    ports:
      - "3306:3306"
    volumes:
      - db-data:/var/lib/mysql
    secrets:
      - mysql_root_password
      - mysql_database
      - mysql_user
      - mysql_password
    restart: always

secrets:
  mysql_root_password:
    external: true
  mysql_database:
    external: true
  mysql_user:
    external: true
  mysql_password:
    external: true

volumes:
  db-data:
    driver: local
    driver_opts:
      type: none
      device: ~/data/db-data
      o: bind
```

### Summary

- **Environment Variables**: The script checks for `MYSQL_` and `MARIADB_` environment variables.
- **Secrets**: If environment variables are not set, the script checks for secrets in the `/run/secrets/` directory.
- **File Variables**: The script also handles `_FILE` variables to read values from files.



#### 1.1.4. Test the mariadb container
Now, you can build your container and tests it. Inside the folder `mariadb`, run the following command. `build` is the command to build the image, and `-t` is the tag name and `mariadb` is the name that I recommend and `.` indicates that the `Dockerfile` is in the current folder.
```bash
docker build -t mariadb .
```
Then, run the container with the following command. `run` is the command to run the container, `-d` is the flag to run the container in background, and `mariadb` is the name of the image that we want to run.
```bash
docker run -d mariadb
```
Now, run the following command to check if the container is running and get its ID.
```bash
docker ps -a
```
With the ID copied, run the next command to get inside the container. `exec` is the command to execute a command inside the container, `-it` is the flag to run the command in interactive mode, and `ID` is the ID of the container and `/bin/bash` is the command that we want to execute, in this case we want to use its terminal.
```bash
docker exec -it copiedID /bin/bash
```
Now, you are inside the container. Run the following command to check if the database is created correctly and running. 
```bash
mysql -u theuser -p thedatabase
```
if you see the the prompt `MariaDB [thedatabase]>` it means that all is ok. Too see the tables, run the following command. For now, we don't have any table, so it'll return an empty set, But at the end of the project, it'll have some tables created by wordpress.
```bash
SHOW TABLES;
```
Now, to exit mysql, run `exit` then run `exit` again to exit the container. So it's all working, then we'll clean our container test. To stop the container, remove it and the image run the following commands.
```bash
docker rm -f $(docker ps -aq) &&  docker rmi -f $(docker images -aq)
```

## links
https://mariadb.org/download/  
