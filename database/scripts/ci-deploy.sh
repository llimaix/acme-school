#!/bin/bash
# ============================================================
# ACME SCHOOL - Deploy de infraestructura Oracle
# Lee las credenciales desde el .env del servidor
# ============================================================

set -e

PROJECT_DIR="/opt/acme-school/database"
cd "$PROJECT_DIR"

echo "=== 1. Verificando Docker ==="
docker --version
docker compose version

echo "=== 2. Verificando .env ==="
if [ ! -f "$PROJECT_DIR/.env" ]; then
    echo "ERROR: No se encuentra $PROJECT_DIR/.env"
    echo "Crea el archivo en el servidor con las variables:"
    echo "  ORACLE_PASSWORD=..."
    echo "  APP_USER=..."
    echo "  APP_USER_PASSWORD=..."
    exit 1
fi
echo "  .env encontrado"

# Cargar variables para verificación
set -a
source "$PROJECT_DIR/.env"
set +a

if [ -z "$ORACLE_PASSWORD" ]; then
    echo "ERROR: ORACLE_PASSWORD no está definida en .env"
    exit 1
fi
echo "  ORACLE_PASSWORD: definida (${#ORACLE_PASSWORD} caracteres)"
echo "  APP_USER: ${APP_USER:-(no definido)}"

echo "=== 3. Aplicando configuración (levanta o actualiza) ==="
docker compose up -d --remove-orphans

echo "=== 4. Esperando que Oracle esté healthy ==="
ATTEMPTS=0
MAX_ATTEMPTS=30
until docker inspect --format='{{.State.Health.Status}}' acme-school-db 2>/dev/null | grep -q "healthy"; do
    ATTEMPTS=$((ATTEMPTS + 1))
    if [ $ATTEMPTS -ge $MAX_ATTEMPTS ]; then
        echo "ERROR: Oracle no arrancó después de $MAX_ATTEMPTS intentos"
        docker logs --tail 50 acme-school-db
        exit 1
    fi
    echo "  Esperando Oracle... (intento $ATTEMPTS/$MAX_ATTEMPTS)"
    sleep 10
done
echo "Oracle está listo."

echo "=== 5. Verificación ==="
docker exec acme-school-db bash -c "echo 'SELECT BANNER FROM V\$VERSION;
EXIT;' | sqlplus -s system/${ORACLE_PASSWORD}@FREEPDB1"

echo ""
echo "=== Oracle corriendo y consistente ==="
echo "  Container: $(docker inspect --format='{{.State.Status}}' acme-school-db)"
echo "  Health: $(docker inspect --format='{{.State.Health.Status}}' acme-school-db)"
echo "  Port: 1521"
echo "  Service: FREEPDB1"
echo "  System user: system / ORACLE_PASSWORD del .env"
[ -n "$APP_USER" ] && echo "  App user: $APP_USER / APP_USER_PASSWORD del .env"
