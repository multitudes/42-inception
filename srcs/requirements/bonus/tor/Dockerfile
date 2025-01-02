# the official nginx image
FROM nginx:latest

# Install OpenSSH and Tor
RUN apt-get update && \
    apt-get install -y openssh-server tor && \
    mkdir /var/run/sshd

# Set the root password
RUN echo 'root:password' | chpasswd

# Create SSH directory and copy public key
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh
COPY tools/id_ed25519.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys && \
    chown -R root:root /root/.ssh

# Copy custom configuration files
COPY tools/sshd_config /etc/ssh/sshd_config
COPY tools/torrc /etc/tor/torrc
COPY tools/nginx.conf /etc/nginx/nginx.conf
COPY tools/html /usr/share/nginx/html

# Start SSH and Tor services, then start) Nginx
CMD service ssh start && service tor start && nginx -g 'daemon off;'


