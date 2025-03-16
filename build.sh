#!/bin/bash

IMAGE_NAME="algomlop/acestream-http-proxy"
IMAGE_TAG="latest"

# Detectar arquitectura
ARCH=$(uname -m)

# Asignar el Dockerfile según la arquitectura
case "$ARCH" in
    x86_64)
        DOCKERFILE="Dockerfile.amd64"
        ;;
    aarch64)
        DOCKERFILE="Dockerfile.arm64"
        ;;
    armv7l)
        DOCKERFILE="Dockerfile.armv7"
        ;;
    *)
        echo "Arquitectura no soportada: $ARCH"
        exit 1
        ;;
esac

# Verificar si el Dockerfile específico existe
if [ ! -f "$DOCKERFILE" ]; then
    echo "Error: $DOCKERFILE no encontrado."
    exit 1
fi

# Renombrar el Dockerfile temporalmente
cp "$DOCKERFILE" Dockerfile

# Crear builder si no existe
if ! docker buildx inspect mybuilder &>/dev/null; then
  echo "Creating new builder multi-platform..."
  docker buildx create --name mybuilder --use
fi

docker buildx use mybuilder

echo "Building with $DOCKERFILE..."
docker buildx build   --platform linux/amd64,linux/arm64,linux/arm/v7   -t "${IMAGE_NAME}:${IMAGE_TAG}"   --push   .

# Restaurar estado eliminando el Dockerfile temporal
rm Dockerfile

echo "Completed"
