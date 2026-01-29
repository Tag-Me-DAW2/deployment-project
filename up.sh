#!/bin/bash
ENV=${1:-prod}
if [ "$ENV" = "prod" ]; then
  export VIRTUAL_HOST_CLIENT=producciondaw.cip.fpmislata.com
else
  export VIRTUAL_HOST_CLIENT=preproducciondaw.cip.fpmislata.com
fi

export BUILD_ENV=$ENV

docker compose down
docker compose build --no-cache
docker compose up -d
