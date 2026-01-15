#!/usr/bin/env bash
set -e

# ==============================
# CONFIGURACIÓN
# ==============================
NEXTCLOUD_DOMAIN="cloud.ideaticloud.com"
COMPOSE_DIR="/opt/nextcloud"
CONTAINER_NAME="nextcloud"

# ==============================
# VALIDACIONES
# ==============================
if [ ! -d "$COMPOSE_DIR" ]; then
  echo "❌ No existe el directorio $COMPOSE_DIR"
  exit 1
fi

cd "$COMPOSE_DIR"

if ! docker compose ps >/dev/null 2>&1; then
  echo "❌ docker compose no está disponible o no hay stack activo"
  exit 1
fi

# ==============================
# CONFIGURACIÓN NEXTCLOUD
# ==============================
echo "🔧 Configurando Nextcloud para Cloudflare Tunnel..."

docker compose exec -u www-data "$CONTAINER_NAME" php occ config:system:set trusted_domains 1 \
  --value="$NEXTCLOUD_DOMAIN"

docker compose exec -u www-data "$CONTAINER_NAME" php occ config:system:set overwriteprotocol \
  --value="https"

docker compose exec -u www-data "$CONTAINER_NAME" php occ config:system:set overwrite.cli.url \
  --value="https://$NEXTCLOUD_DOMAIN"

# ==============================
# FINAL
# ==============================
echo "✅ Configuración aplicada correctamente"
echo "🌐 Acceso: https://$NEXTCLOUD_DOMAIN"
