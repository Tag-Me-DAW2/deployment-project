#!/bin/bash
 
ENV=${1:-production}

export BUILD_ENV=$ENV

docker compose down
docker compose build --no-cache
docker compose up -d
