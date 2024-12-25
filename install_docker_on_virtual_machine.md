# install docker on virtual machine

Yes, you need to install Docker on your virtual machine to create and run Docker containers. Here are the steps to install Docker and create a Dockerfile for NGINX with TLSv1.2 or TLSv1.3 only:

### Install Docker on Debian

1. **Update the package list**:
   ```sh
   sudo apt update
   ```

2. **Install required packages**:
   ```sh
   sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
   ```

3. **Add Docker’s official GPG key**:
   ```sh
   curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
   ```

4. **Set up the stable repository**:
   ```sh
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

5. **Install Docker Engine**:
   ```sh
   sudo apt update
   sudo apt install docker-ce docker-ce-cli containerd.io
   ```

6. **Verify Docker installation**:
   ```sh
   sudo docker run hello-world
   ```

### Create a Dockerfile for NGINX with TLSv1.2 or TLSv1.3

1. **Create a directory for your Dockerfile**:
   ```sh
   mkdir nginx-tls
   cd nginx-tls
   ```

2. **Create a Dockerfile**:
   ```Dockerfile
   # filepath: nginx-tls/Dockerfile
   FROM nginx:alpine

   # Install OpenSSL
   RUN apk add --no-cache openssl

   # Copy custom NGINX configuration
   COPY nginx.conf /etc/nginx/nginx.conf

   # Expose port 443 for HTTPS
   EXPOSE 443

   CMD ["nginx", "-g", "daemon off;"]
   ```

3. **Create an NGINX configuration file**:
   ```nginx
   # filepath: nginx-tls/nginx.conf
   events {}

   http {
       server {
           listen 443 ssl;

           ssl_protocols TLSv1.2 TLSv1.3;
           ssl_certificate /etc/nginx/ssl/nginx.crt;
           ssl_certificate_key /etc/nginx/ssl/nginx.key;

           location / {
               root /usr/share/nginx/html;
               index index.html;
           }
       }
   }
   ```

4. **Generate self-signed SSL certificates**:
   ```sh
   mkdir -p nginx/ssl
   openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx/ssl/nginx.key -out nginx/ssl/nginx.crt -subj "/CN=localhost"
   ```

5. **Build the Docker image**:
   ```sh
   sudo docker build -t nginx .
   ```

6. **Run the Docker container**:
   ```sh
   sudo docker run -d -p 443:443 --name nginx-tls-container nginx-tls
   ```

This will set up an NGINX container with TLSv1.2 and TLSv1.3 only.

Similar code found with 1 license type


## why the GPG key is added?
Adding Docker’s official GPG key ensures that the Docker packages you download are authentic and have not been tampered with. This step is crucial for security reasons, as it verifies the integrity and origin of the packages.

Here’s a brief explanation of the steps involved:

1. **GPG Key**: The GPG key is used to sign Docker packages. By adding Docker’s official GPG key to your system, you allow your package manager to verify the authenticity of the Docker packages.

2. **Repository Setup**: When you add the Docker repository to your system, the package manager will use the GPG key to check the signatures of the packages. This ensures that the packages are from Docker and have not been altered.

Without adding the GPG key, your package manager would not be able to verify the authenticity of the Docker packages, and you might encounter security warnings or errors during installation.


## why do i need to use sudo
If you need to use `sudo` to run Docker commands inside your virtual machine, it means your user does not have the necessary permissions to access the Docker daemon. This is typically because your user is not part of the `docker` group.

To allow your user to run Docker commands without `sudo`, you need to add your user to the `docker` group. Here are the steps:

1. **Add User to Docker Group**:
   ```sh
   sudo usermod -aG docker $USER
   ```

2. **Log Out and Log Back In**: For the changes to take effect, log out of your current session and log back in. Alternatively, you can reboot your virtual machine:
   ```sh
   sudo reboot
   ```

3. **Verify Docker Group Membership**: After logging back in, verify that your user is part of the `docker` group:
   ```sh
   groups
   ```

4. **Run Docker Commands Without `sudo`**: You should now be able to run Docker commands without needing `sudo`.

If you still encounter issues, ensure that the Docker service is running and that your user is correctly added to the `docker` group.