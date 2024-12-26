# what is mariadb

MariaDB is a community-developed fork of the MySQL relational database management system intended to remain free under the GNU GPL. Being a fork of a leading open source software system, it is notable for being led by its original developers.
Oracle Corporation, the original developers of MySQL, created a new non-free version of MySQL (version 5.5), which is why the developers of MariaDB decided to create their own fork of MySQL. MariaDB intends to maintain high compatibility with MySQL.

# install a mariadb docker container

with the most basic dockerfile you can create a mariadb container

```Dockerfile

```

to start it you can run the following commands

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

## links
https://mariadb.org/download/  
