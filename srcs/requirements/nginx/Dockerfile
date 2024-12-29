# The latest version of alpine is 3.21
# therefore, we are using 3.20
FROM alpine:3.20

RUN apk update && apk upgrade

# Install openssl and nginx. Dont use any previous cache
RUN apk add --no-cache openssl nginx gettext
RUN mkdir -p /var/www/html/

# copy conf file
COPY	./tools/nginx.conf /etc/nginx/nginx.conf

# openssl is used to generate a self-signed certificate
RUN 	openssl req -x509 -nodes -days 365 -newkey rsa:2048\
		-keyout /etc/ssl/private/nginx-selfsigned.key\
		-out /etc/ssl/certs/nginx-selfsigned.crt\
		-subj "/C=DE/ST=IDF/L=BERLIN/O=42Network/OU=42BERLIN/CN=lbrusa.42.de"

# create a user www and change the ownership of the files in the /run/nginx/ directory
RUN		adduser -D -g 'www' www &&\
		chown -R www:www /run/nginx/ &&\
		chown -R www:www /var/www/html/

# Expose NGINX ports
EXPOSE 443/tcp

# start nginx running in the background
CMD ["nginx", "-g", "daemon off;"]