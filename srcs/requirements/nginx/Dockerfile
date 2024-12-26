# The latest version of alpine is 3.21
# therefore, we are using 3.20
FROM alpine:3.20
RUN apk update && apk upgrade

# Install openssl and nginx. Dont use any previous cache
RUN apk add --no-cache openssl nginx 

# Copy the nginx configuration file
COPY tools/conf /etc/nginx/nginx.conf

# Copy the ssl certificate and key - copy is recursive
COPY tools/ssl /etc/nginx/ssl

# I will use port 443 but no need to expose it here
# it will be exposed in the docker run command or docker compose

# start nginx running in the background
CMD ["nginx", "-g", "daemon off;"]