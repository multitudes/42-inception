# secrets

## in the Docker compose file
```yaml
secrets:
  db_password:
    file: ../secrets/db_password.txt
  db_root_password:
    file: ../secrets/db_root_password.txt
  wp_admin_password:
    file: ../secrets/wp_admin_password.txt
  wp_user_password:
    file: ../secrets/wp_user_password.txt   
```

and attached to the service
```yaml
	#[...]
    secrets:
      - wp_admin_password
      - wp_user_password
      - db_password
```
The above secrets are stored in the `secrets` directory in the root of the project. I see in the documentation that it is common to pass the paths to the secrets in these environmental variables.  
```yaml
	environment:
	  MYSQL_ROOT_PASSWORD_FILE: /run/secrets/db_root_password
	  MYSQL_PASSWORD_FILE: /run/secrets/db_password
	  MYSQL_USER_FILE: /run/secrets/db_user
```

## Inside the container 
I usually have a bash script. The environmental variables are passed to the script and I can read them:  
```bash
#!/bin/bash
# Function to read secret from file
read_secret() {
    local secret_file="$1"
    if [ -f "$secret_file" ] && [ -r "$secret_file" ]; then
        cat "$secret_file"
    else
        echo "Error reading secret from $secret_file"
    fi
}

# read secrets
MYSQL_PASSWORD=$(read_secret $WORDPRESS_DB_PASSWORD_FILE)
WP_ADMIN_PASS=$(read_secret $WORDPRESS_ADMIN_PASSWORD_FILE)
WP_USER_PASS=$(read_secret $WORDPRESS_USER_PASSWORD_FILE)
```

The function to read the secret from the file is not strictly necessary but it is a good practice.
The flags -f and -r are used to check if the file exists and is readable.

## Links
https://docs.docker.com/engine/swarm/secrets/#:~:text=The%20location%20of%20the%20mount,ProgramData%5CDocker%5Csecrets%20in%20Windows  