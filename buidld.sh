#!/bin/bash

# Nombre de la imagen y etiqueta
IMAGE_NAME="algomlop/acestream-http-proxy"
IMAGE_TAG="latest"

# Crear un nuevo builder si no existe
if ! docker buildx inspect mybuilder &>/dev/null; then
  echo "Creando nuevo builder multi-plataforma..."
  docker buildx create --name mybuilder --use
fi

# Asegurarse de que el builder está en uso
docker buildx use mybuilder

# Construir para múltiples plataformas
echo "Construyendo imagen para múltiples arquitecturas..."
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t "${IMAGE_NAME}:${IMAGE_TAG}" \
  --push \
  .

echo "Construcción completada"
