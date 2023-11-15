#!/bin/bash

# Define the path to certificates, config and data
HOST_CERTS_PATH="/srv/caddy/certs"
CONTAINER_CERTS_PATH="/etc/caddy/certs"
HOST_CADDYFILE_PATH="/srv/caddy/Caddyfile"
HOST_DATA_PATH="/srv/caddy/data"
HOST_CONFIG_PATH="/srv/caddy/config"
HOST_MEDIA_PATH="/srv/caddy/media"
HOST_STATIC_PATH="/srv/caddy/static"

# Run Caddy Docker container with mounted certificates
docker run -d --name sorccaddy --network sorc_network -p 80:80 -p 443:443 \
  --restart unless-stopped \
  -v $HOST_CERTS_PATH:$CONTAINER_CERTS_PATH \
  -v $HOST_CADDYFILE_PATH:/etc/caddy/Caddyfile:ro \
  -v $HOST_DATA_PATH:/data \
  -v $HOST_MEDIA_PATH:/media \
  -v $HOST_STATIC_PATH:/static \
  -v $HOST_CONFIG_PATH:/config \
  -u $(id -u apprunner):$(id -g apprunner) \
  caddy:2-alpine
