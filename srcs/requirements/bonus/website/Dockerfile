# I am using the debian image to run the busybox HTTP server
# because the alpine image does not have the httpd package and 
# gives an applets not found error when trying to run the httpd command
# a better alternative would be to use the busybox official image
# to have a smaller size but the subject requires the use 
# of the alpine or debian images

FROM debian:11

RUN apt update && apt install -y busybox && \
	rm -rf /var/lib/apt/lists/*

# Set the working directory - will create if it does not exist
WORKDIR	/var/www/website

# Copy the website source code
COPY		./srcs/* /var/www/website/

# Start busybox HTTP server on port 8081
ENTRYPOINT ["busybox", "httpd", "-f", "-p", "8081"]
