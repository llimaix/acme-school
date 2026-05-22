#!/bin/bash
# ============================================================
# ACME SCHOOL - Deploy de infraestructura Oracle
# Levanta Oracle, verifica health, y si hay cambios en la
# configuración de Docker (imagen, volúmenes, etc.) recrea
# el contenedor manteniendo los datos persistentes.
# ============================================================

set -e

PROJECT_DIR="/opt/acme-school/database"
cd "$PROJECT_DIR"

echo "=== 1. Verificando Docker ==="
docker --version
docker compose version

echo "=== 2. Aplicando configuración (levanta o actualiza) ==="
docker compose up -d --remove-orphans

echo "=== 3. Esperando que Oracle esté healthy ==="
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

echo "=== 4. Verificación ==="
docker exec acme-school-db bash -c "echo 'SELECT BANNER FROM V\$VERSION;
EXIT;' | sqlplus -s system/AcmeSchool2025@FREEPDB1"

echo "=== 5. Estado de volúmenes ==="
echo "  oracle-data:"
docker volume inspect acme-school_oracle-data --format '  Size: {{.UsageData.Size}} bytes' 2>/dev/null || echo "  (info no disponible)"
echo "  oracle-backups:"
docker volume inspect acme-school_oracle-backups --format '  Size: {{.UsageData.Size}} bytes' 2>/dev/null || echo "  (info no disponible)"

echo ""
echo "=== Oracle corriendo y consistente ==="
echo "  Container: $(docker inspect --format='{{.State.Status}}' acme-school-db)"
echo "  Health: $(docker inspect --format='{{.State.Health.Status}}' acme-school-db)"
echo "  Uptime: $(docker inspect --format='{{.State.StartedAt}}' acme-school-db)"
echo "  Port: 1521"
echo "  Service: FREEPDB1"
