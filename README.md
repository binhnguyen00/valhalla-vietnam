# Valhalla Routing Engine for Vietnam

This project sets up the Valhalla routing engine with Vietnam OSM data for local routing capabilities.

## Overview

Valhalla is an open-source routing engine that provides turn-by-turn navigation and route planning. This project demonstrates how to set up Valhalla with Vietnamese OpenStreetMap (OSM) data for local routing applications.

## Features

- Pre-configured Valhalla container with Vietnam OSM data
- Ready-to-use routing tiles for Vietnam
- Simple setup and deployment process
- Docker-based architecture for easy deployment

## Prerequisites

- Docker installed on your system
- At least 2GB of available disk space for OSM data and routing tiles

## Quick Start

1. Clone this repository
2. Run `./helper.sh` to download OSM data and build routing tiles
3. Start the Valhalla service with `docker-compose up -d`
4. Access the routing API at `http://localhost:8092`

## Configuration

The `valhalla.json` file contains the routing engine configuration. You can modify this file to adjust routing parameters such as:

- Costing options (auto, bicycle, pedestrian, etc.)
- Timezone and administrative boundary settings
- Tile generation parameters

For more information on Valhalla configuration options, refer to the [official Valhalla documentation](https://github.com/valhalla/valhalla/blob/master/docs/data/valhalla.json).