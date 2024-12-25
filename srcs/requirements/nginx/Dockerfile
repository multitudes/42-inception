# The latest version of alpine is 3.21
# therefore, we are using 3.20
FROM nginx:alpine3.20

# Install openssl. Dont use any previous cache
RUN apk add --no-cache openssl

# Copy the nginx configuration file
COPY conf /etc/nginx/nginx.conf

# Copy the ssl certificate and key - copy is recursive
COPY ssl /etc/nginx/ssl


# I will use port 443 but no need to expose it here
# it will be exposed in the run command

CMD ["nginx", "-g", "daemon off;"]