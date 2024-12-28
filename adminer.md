# Adminer

As a bonus adding adminer could not be easier
I can just add this container to the docker network and it will be able to connect to the mariadb container. I can access Adminer by navigating to http://localhost:8080 in my web browser.  
I will use the following credentials to log in:

System: MySQL
Server: mariadb (or the name of your MariaDB service)
and from the .env file
Username: MYSQL_USER 
Password: MYSQL_PASSWORD 
Database: MYSQL_DATABASE 

```yaml

  adminer:
    image: adminer
    restart: on-failure
    ports:
      - 8080:8080
    networks:
      - inception_network
```		

Also, I can write a docker file for adminer and build it from alpine like I did for the other containers.

```yaml
  adminer:
    build: requirements/adminer
    ports:
      - 8080:8080
    expose:
      - 9000
    networks:
      - inception_network
    depends_on:
      - wordpress
    restart: on-failure

```
with its own dockerfile
```dockerfile


```



## testing the mariadb setup with adminer
To test your MariaDB setup using Adminer, you can perform a few basic SQL commands to verify that your database is working correctly. Here are some common SQL commands you can use:

### 1. Show Databases
This command lists all the databases available on the MariaDB server.
```sql
SHOW DATABASES;
```

### 2. Use a Specific Database
This command selects a specific database to work with.
```sql
USE mydatabase;
```

### 3. Show Tables
This command lists all the tables in the selected database.
```sql
SHOW TABLES;
```

### 4. Create a Table
This command creates a new table in the selected database.
```sql
CREATE TABLE test_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 5. Insert Data into a Table
This command inserts a new row into the table.
```sql
INSERT INTO test_table (name) VALUES ('Test Name');
```

### 6. Select Data from a Table
This command retrieves data from the table.
```sql
SELECT * FROM test_table;
```

### 7. Update Data in a Table
This command updates existing data in the table.
```sql
UPDATE test_table SET name = 'Updated Name' WHERE id = 1;
```

### 8. Delete Data from a Table
This command deletes data from the table.
```sql
DELETE FROM test_table WHERE id = 1;
```

### 9. Drop a Table
This command deletes the table from the database.
```sql
DROP TABLE test_table;
```

### Steps to Perform in Adminer:
1. **Log In to Adminer**:
   - **System**: MySQL
   - **Server**: `mariadb` (or the name of your MariaDB service)
   - **Username**: `MYSQL_USER` (from your 

.env

 file)
   - **Password**: `MYSQL_PASSWORD` (from your 

.env

 file)
   - **Database**: `MYSQL_DATABASE` (from your 

.env

 file)

2. **Navigate to the SQL Command Page**:
   - Click on the "SQL command" link in the Adminer interface.

3. **Execute SQL Commands**:
   - Copy and paste the SQL commands provided above into the SQL command text area.
   - Click the "Execute" button to run the commands.

### Example SQL Commands:
```sql
-- Show all databases
SHOW DATABASES;

-- Use the specific database
USE mydatabase;

-- Show all tables in the database
SHOW TABLES;

-- Create a new table
CREATE TABLE test_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert data into the table
INSERT INTO test_table (name) VALUES ('Test Name');

-- Select data from the table
SELECT * FROM test_table;

-- Update data in the table
UPDATE test_table SET name = 'Updated Name' WHERE id = 1;

-- Delete data from the table
DELETE FROM test_table WHERE id = 1;

-- Drop the table
DROP TABLE test_table;
```

### Summary:
- **Log In to Adminer**: Use the credentials from your 

.env

 file.
- **Execute SQL Commands**: Use the provided SQL commands to test your MariaDB setup.
- **Verify Results**: Ensure that the commands execute successfully and return the expected results.


## Links
https://github.com/vrana/adminer  

btw adminer is deprecated as mentioned on the docker page:  
https://hub.docker.com/_/adminer