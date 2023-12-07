#!/bin/bash

# Define the path to django related directories
DOCKER_COMPOSE_FILE_PATH="/srv/django/docker-compose.prod.yml"

# Set default value for the image tag if argument is not supplied
DOCKER_IMAGE_TAG="ghcr.io/vi-klaas/red_companion:latest"

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        --docker-image-tag=*)
        DOCKER_IMAGE_TAG="${arg#*=}"
        shift # Remove --docker-image-tag= from processing
        ;;
        --docker-compose-file=*)
        DOCKER_COMPOSE_FILE_PATH="${arg#*=}"
        shift # Remove --docker-compose-file= from processing
        ;;
        *)
        shift
        ;;
    esac
done

# Pull the latest image from registry
docker pull "$DOCKER_IMAGE_TAG"

# Use docker-compose to start up the Django service
docker compose -f "$DOCKER_COMPOSE_FILE_PATH" pull
docker compose -f "$DOCKER_COMPOSE_FILE_PATH" up -d
