FROM		debian:11

# Create the working directory
RUN			mkdir -p /var/www/website

# Set the working directory
WORKDIR	/var/www/website

# Copy the website source code
COPY		./srcs/* /var/www/website/

# Install busybox
RUN			apt update && apt install -y busybox

# Start busybox HTTP server
CMD			["busybox", "httpd", "-f", "-p", "8081"]

# FROM alpine:3.20

# RUN apk update && apk upgrade 
# RUN	apk add --no-cache lighttpd

# # Set the working directory
# WORKDIR /var/www/website

# # Copy the website source code
# COPY ./tools/index.html /var/www/website/
# COPY ./tools/lighttpd.conf /etc/lighttpd/lighttpd.conf

# CMD chown -R www-data:www-data /var/www/website && \
# 	chmod -R 755 /var/www/website

# ENTRYPOINT [ "lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf" ]