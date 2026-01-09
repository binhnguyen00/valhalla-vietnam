# Configuration for Valhalla build with Windows/Git Bash compatibility.
export MSYS_NO_PATHCONV=1

URL="https://download.geofabrik.de/asia/vietnam-latest.osm.pbf"
OUTPUT="vietnam-latest.osm.pbf"

if [ ! -f "$OUTPUT" ]; then
  echo "Downloading OSM data..."
  curl -L -C - "$URL" -o "$OUTPUT"
fi

IMAGE="ghcr.io/valhalla/valhalla:latest"
if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "Pulling image..."
  docker pull "$IMAGE"
fi

echo "Starting Valhalla container..."
docker run -dt --name valhalla -v "/$(pwd):/custom_files" "$IMAGE"

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

echo "Cleaning up..."
docker stop valhalla && docker rm valhalla
