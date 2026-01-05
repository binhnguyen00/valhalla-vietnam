#!/bin/bash

URL="https://download.geofabrik.de/asia/vietnam-latest.osm.pbf"
OUTPUT="vietnam-latest.osm.pbf"

if [ ! -f "$OUTPUT" ]; then
  echo "Downloading OSM data..."
  curl -L -C - "$URL" -o "$OUTPUT"
fi

IMAGE="ghcr.io/valhalla/valhalla:latest"
if docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "Image exists locally."
else
  echo "Image not found. Pulling now..."
  docker pull "$IMAGE"
fi

echo "Starting Valhalla container..."
docker run -dt --name valhalla -v "$(pwd)":/custom_files ghcr.io/valhalla/valhalla:latest

echo "Building Valhalla configuration..."
docker exec valhalla bash -c "valhalla_build_config \
  --mjolnir-tile-dir /custom_files/valhalla_tiles \
  --mjolnir-tile-extract /custom_files/valhalla_tiles.tar \
  --mjolnir-timezone /custom_files/valhalla_tiles/timezones.sqlite \
  --mjolnir-admin /custom_files/valhalla_tiles/admins.sqlite \
  > /custom_files/valhalla.json"

echo "Building tiles..."
docker exec valhalla valhalla_build_tiles -c /custom_files/valhalla.json /custom_files/vietnam-latest.osm.pbf

echo "Creating tile archive..."
docker exec valhalla bash -c "tar -cvf /custom_files/valhalla_tiles.tar -C /custom_files valhalla_tiles"

echo "Cleaning up container..."
docker stop valhalla && docker rm valhalla