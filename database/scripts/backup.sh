#!/bin/bash
# ============================================================
# ACME SCHOOL - Backup manual de la base de datos
# Crea un export Data Pump del schema acme_school
# ============================================================

set -e

GREEN='\033[0;32m'
NC='\033[0m'
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="acme_school_${TIMESTAMP}"

log_info "Creando backup: ${BACKUP_NAME}.dmp"

docker exec acme-school-db bash -c "
  expdp system/\${ORACLE_PASSWORD:-AcmeSchool2025}@FREEPDB1 \
    DIRECTORY=DATA_PUMP_DIR \
    DUMPFILE=${BACKUP_NAME}.dmp \
    LOGFILE=${BACKUP_NAME}.log \
    SCHEMAS=acme_school
"

# Copiar backup fuera del contenedor
mkdir -p "$(dirname "$0")/../backups"
docker cp "acme-school-db:/opt/oracle/admin/FREE/dpdump/${BACKUP_NAME}.dmp" \
    "$(dirname "$0")/../backups/${BACKUP_NAME}.dmp"

log_info "Backup guardado en: database/backups/${BACKUP_NAME}.dmp"
log_info "Tamaño: $(du -h "$(dirname "$0")/../backups/${BACKUP_NAME}.dmp" | cut -f1)"
