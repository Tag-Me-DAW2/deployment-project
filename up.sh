#!/bin/bash
set -e

if [[ "$1" != "prod" && "$1" != "preprod" ]]; then
  echo "Uso: $0 [prod|preprod]"
  exit 1
fi

if [[ "$1" == "prod" ]]; then
  BRANCH="main"
  BUILD_ENV="prod"
  VIRTUAL_HOST_CLIENT="producciondaw.cip.fpmislata.com"
else
  BRANCH="develop"
  BUILD_ENV="preprod"
  VIRTUAL_HOST_CLIENT="preproducciondaw.cip.fpmislata.com"
fi

echo "Desplegando $1 (rama $BRANCH)..."

export GIT_BRANCH=$BRANCH
export BUILD_ENV=$BUILD_ENV
export VIRTUAL_HOST_CLIENT=$VIRTUAL_HOST_CLIENT
docker-compose build --pull
docker-compose up -d

echo "Despliegue finalizado."
