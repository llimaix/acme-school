#!/bin/bash
# ============================================================
# ACME SCHOOL - Reset completo de la base de datos
# CUIDADO: Destruye todos los datos y recrea desde cero
# ============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo -e "${RED}=========================================="
echo "  ⚠️  RESET COMPLETO DE BASE DE DATOS"
echo "  Esto DESTRUIRÁ todos los datos."
echo -e "==========================================${NC}"
echo ""
read -p "¿Estás seguro? (escribe 'SI' para confirmar): " confirm

if [ "$confirm" != "SI" ]; then
    echo "Cancelado."
    exit 0
fi

cd "$(dirname "$0")/.."

log_info "Deteniendo contenedor..."
docker compose down -v

log_info "Eliminando volumen de datos..."
docker volume rm acme-school_oracle-data 2>/dev/null || true

log_info "Recreando desde cero..."
docker compose up -d

log_info "Esperando que Oracle inicie (puede tomar 2-3 minutos)..."
sleep 30

timeout 300 bash -c 'until docker inspect --format="{{.State.Health.Status}}" acme-school-db 2>/dev/null | grep -q "healthy"; do echo "  Esperando..."; sleep 10; done'

log_info "Oracle listo. Los init-scripts se ejecutaron automáticamente."
log_info ""
log_info "Conexión:"
log_info "  Host: localhost"
log_info "  Port: 1521"
log_info "  Service: FREEPDB1"
log_info "  User: acme_school"
log_info "  Pass: AcmeSchool2025"
