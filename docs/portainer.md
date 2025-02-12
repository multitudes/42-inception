# portainer

- Provides a web-based GUI for easily managing containers, images, networks, volumes, and more. 
- Easily deploy, start, stop, restart, and remove containers.
- Manage Docker images, including pulling, pushing, and building new images.
- Create and manage Docker networks and volumes.
- Control access to different parts of the Portainer interface for different users.
- Provides basic monitoring and logging capabilities for your containers.
- Can be easily deployed as a single Docker container.

**How to Use Portainer:**

1. **Install Portainer:**
   - Run the following command in your terminal:

     ```bash
     docker run -d -p 9000:9000 -p 8000:8000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
     ```

   - This command:
     - Runs the Portainer container in detached mode (`-d`).
     - Exposes ports 9000 (HTTP) and 8000 (HTTPS) for access.
     - Mounts the Docker socket (`/var/run/docker.sock`) to allow Portainer to interact with the Docker daemon.
     - Creates a persistent volume (`portainer_data`) to store Portainer's data.

2. **Access Portainer:**
   - Open your web browser and navigate to `http://localhost:9000` or `https://localhost:8000`.
   - Follow the on-screen instructions to create an administrator account.

3. **Manage Your Docker Environment:**
   - Use the Portainer interface to manage your containers, images, networks, and more.


## in docker compose
```yaml
  portainer:
    build: ./requirements/portainer/
    env_file: .env
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
      - prt_files:/data
    restart: on-failure
    depends_on:
      - wordpress
    networks:
      - inception_network
    ports:
      - "9443:9443"
```


## ports
Exposing only port 9443 for Portainer is generally the recommended and secure approach. 

Here's why:

* **Security:**
    - **HTTPS (port 9443):** Encrypts all communication between your browser and Portainer, protecting sensitive information like usernames, passwords, and container configurations.
    - **Reduced Attack Surface:** Exposing only the HTTPS port minimizes the potential attack surface by removing unnecessary open ports.

* **Intended Use:**
    - Portainer is primarily designed to be accessed securely over HTTPS. 

**Regarding Port 8000:**

- Port 8000 is typically used for internal communication and may not be necessary for typical usage. 

## links

https://github.com/portainer/portainer/issues/5754
