#!/bin/sh

echo "[Redis config] Configuring Redis..."

# sed -i 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis/redis.conf

mkdir -p /etc/redis

cat <<EOF > /etc/redis/redis.conf
# Bind to all network interfaces
bind 0.0.0.0

# Port to listen on
port 6379

# Enable persistence
save 900 1
save 300 10
save 60 10000

# Set the maximum memory usage
maxmemory 256mb
maxmemory-policy allkeys-lru

# Enable append-only file persistence
appendonly yes
protected-mode no
EOF

chown www:www /etc/redis/redis.conf
chmod 644 /etc/redis/redis.conf

# Create a user www and change the ownership of the Redis configuration directory
adduser -D -g 'www' www && \
mkdir -p /var/lib/redis && \
mkdir -p /etc/redis && \
chown -R www:www /var/lib/redis && \
chown -R www:www /etc/redis

echo "[Redis config] Starting Redis server on port 6379."

# Start the Redis server
exec redis-server /etc/redis/redis.conf