#!/usr/bin/env bash
set -e

SCRIPT_NAME="$(basename "$0")"

show_help() {
  cat << EOF
Uso:
  $SCRIPT_NAME [prod|preprod]

Sin argumentos:
  - Usa la rama actual (main → prod, develop → preprod)

Ejemplos:
  $SCRIPT_NAME
  $SCRIPT_NAME prod
  $SCRIPT_NAME preprod
EOF
}

# ---------- Help ----------
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  show_help
  exit 0
fi

# ---------- Entorno (manual tiene prioridad) ----------
if [[ "${1:-}" == "prod" || "${1:-}" == "preprod" ]]; then
  BUILD_ENV="$1"
else
  # CI o ejecución normal → usar rama
  BRANCH="${GITHUB_REF_NAME:-$(git branch --show-current)}"

  case "$BRANCH" in
    main)
      BUILD_ENV="prod"
      ;;
    develop)
      BUILD_ENV="preprod"
      ;;
    *)
      echo "ℹ️ Rama '$BRANCH' no despliega"
      exit 0
      ;;
  esac
fi

# ---------- Variables por entorno ----------
case "$BUILD_ENV" in
  prod)
    export VIRTUAL_HOST_CLIENT=producciondaw.cip.fpmislata.com
    export GIT_BRANCH=main
    ;;
  preprod)
    export VIRTUAL_HOST_CLIENT=preproducciondaw.cip.fpmislata.com
    export GIT_BRANCH=develop
    ;;
esac

export BUILD_ENV

echo "🚀 Deploy manual/CI en entorno: $BUILD_ENV"

CACHE_BUST=$(date +%s)
docker compose build --build-arg CACHE_BUST=$CACHE_BUST
docker compose up -d --remove-orphans
