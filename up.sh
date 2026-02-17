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

ROOT_DIR="$(pwd)"
CLONE_DIR="$ROOT_DIR/repos"
mkdir -p "$CLONE_DIR"

REPOS=(
  https://github.com/Tag-Me-DAW2/store-client-frontend.git
  https://github.com/Tag-Me-DAW2/store-admin-frontend.git
  https://github.com/Tag-Me-DAW2/bank-frontend.git
  https://github.com/Tag-Me-DAW2/store-backend.git
  https://github.com/Tag-Me-DAW2/bank-backend.git
)
for entry in "${REPOS[@]}"; do

  url="$entry"
  repo=$(basename -s .git "$url")
  target="$CLONE_DIR/$repo"

  if [ -d "$target/.git" ]; then
    echo "Reseteando $repo en $target a origin/$BRANCH (último commit)..."
    git -C "$target" fetch --depth=1 origin "$BRANCH" || git -C "$target" fetch --all --prune
    git -C "$target" checkout "$BRANCH" || git -C "$target" checkout -b "$BRANCH"
    git -C "$target" reset --hard "origin/$BRANCH"
  else
    echo "Clonando $repo desde $url (rama $BRANCH)..."
    git clone --depth 1 --branch "$BRANCH" "$url" "$target" || {
      echo "AVISO: no se pudo clonar $url. Continúo con el siguiente."
    }
  fi
done

echo "Clones/updates finalizados. Lanzando build..."

docker-compose build --pull
docker-compose up -d

echo "Despliegue finalizado."
