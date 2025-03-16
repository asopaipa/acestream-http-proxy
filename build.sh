#!/bin/bash

IMAGE_NAME="algomlop/acestream-http-proxy"
IMAGE_TAG="latest"

ARCH=$(uname -m)

case "$ARCH" in
    "x86_64") 
        DOCKERFILE="Dockerfile.amd64"
        PLATFORM="linux/amd64"
        ;;
    "aarch64") 
        DOCKERFILE="Dockerfile.arm64"
        PLATFORM="linux/arm64"
        ;;
    "armv7l") 
        DOCKERFILE="Dockerfile.armv7"
        PLATFORM="linux/arm/v7"
        ;;
    *) 
        echo "Not supported architecture: $ARCH"
        exit 1
        ;;
esac


if ! docker buildx inspect mybuilder &>/dev/null; then
  echo "Creating builder multi-plataforma..."
  docker buildx create --name mybuilder --use
fi

docker buildx use mybuilder

echo "Building..."
docker buildx build \
  --platform $PLATFORM \
  -f $DOCKERFILE \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  --push \
  .

echo "Completed."
