#!/bin/bash

# Set your Docker Hub username
DOCKER_USER="m4dsurg3on"
IMAGE_NAME="pihole"
VERSION="2025.03.0"

# Check if logged into Docker Hub
if ! docker info 2>/dev/null | grep -q "Username: $DOCKER_USER"; then
    echo "Please login to Docker Hub first:"
    docker login
fi

# Create builder instance if it doesn't exist
docker buildx create --name multiarch --driver docker-container --use

# Build and push multi-arch images
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ${DOCKER_USER}/${IMAGE_NAME}:latest \
  -t ${DOCKER_USER}/${IMAGE_NAME}:${VERSION} \
  --push .