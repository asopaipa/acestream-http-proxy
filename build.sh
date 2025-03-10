#!/bin/bash


IMAGE_NAME="algomlop/acestream-http-proxy"
IMAGE_TAG="latest"

if ! docker buildx inspect mybuilder &>/dev/null; then
  echo "Creating new builder multi-platform..."
  docker buildx create --name mybuilder --use
fi

docker buildx use mybuilder

echo "Building..."
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  --push \
  .

echo "Completed"
