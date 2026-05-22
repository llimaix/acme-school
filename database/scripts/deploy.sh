#!/bin/bash
# ============================================================
# ACME SCHOOL - Script de despliegue de base de datos
# Ejecuta los scripts SQL en orden contra Oracle
# ============================================================

set -e

# Configuración
ORACLE_HOST="${ORACLE_HOST:-localhost}"
ORACLE_PORT="${ORACLE_PORT:-1521}"
ORACLE_SERVICE="${ORACLE_SERVICE:-FREEPDB1}"
ORACLE_ADMIN_USER="${ORACLE_ADMIN_USER:-system}"
ORACLE_ADMIN_PASS="${ORACLE_ADMIN_PASS:-AcmeSchool2025}"
ORACLE_APP_USER="${ORACLE_APP_USER:-acme_school}"
ORACLE_APP_PASS="${ORACLE_APP_PASS:-AcmeSchool2025}"

SCRIPTS_DIR="$(cd "$(dirname "$0")/../init-scripts" && pwd)"
SQLCL_CMD="sql"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Esperar a que Oracle esté listo
wait_for_oracle() {
    log_info "Esperando a que Oracle esté disponible..."
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if docker exec acme-school-db healthcheck.sh &>/dev/null; then
            log_info "Oracle está listo."
            return 0
        fi
        attempt=$((attempt + 1))
        log_warn "Intento $attempt/$max_attempts - Oracle no está listo aún..."
        sleep 10
    done
    
    log_error "Oracle no respondió después de $max_attempts intentos."
    exit 1
}

# Ejecutar script SQL como admin (system)
run_as_admin() {
    local script="$1"
    log_info "Ejecutando como ADMIN: $(basename $script)"
    docker exec -i acme-school-db sqlplus -s \
        "${ORACLE_ADMIN_USER}/${ORACLE_ADMIN_PASS}@${ORACLE_SERVICE}" <<EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET ECHO ON
SET FEEDBACK ON
@/opt/oracle/scripts/$(basename $script)
EXIT;
EOF
}

# Ejecutar script SQL como app user (acme_school)
run_as_app() {
    local script="$1"
    log_info "Ejecutando como APP: $(basename $script)"
    docker exec -i acme-school-db sqlplus -s \
        "${ORACLE_APP_USER}/${ORACLE_APP_PASS}@${ORACLE_SERVICE}" <<EOF
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET ECHO ON
SET FEEDBACK ON
@/opt/oracle/scripts/$(basename $script)
EXIT;
EOF
}

# Crear backup antes de aplicar cambios
create_backup() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    log_info "Creando backup pre-deploy: backup_${timestamp}.dmp"
    docker exec acme-school-db bash -c "
        expdp ${ORACLE_APP_USER}/${ORACLE_APP_PASS}@${ORACLE_SERVICE} \
            DIRECTORY=DATA_PUMP_DIR \
            DUMPFILE=backup_${timestamp}.dmp \
            LOGFILE=backup_${timestamp}.log \
            SCHEMAS=${ORACLE_APP_USER} \
            2>/dev/null || echo 'Backup skipped (schema may not exist yet)'
    "
}

# Flujo principal
main() {
    log_info "=========================================="
    log_info "  ACME SCHOOL - Database Deploy"
    log_info "=========================================="
    
    wait_for_oracle
    
    # Backup antes de cambios (si la BD ya existe)
    create_backup
    
    # Copiar scripts al contenedor
    log_info "Copiando scripts al contenedor..."
    docker cp "${SCRIPTS_DIR}/." acme-school-db:/opt/oracle/scripts/
    
    # Ejecutar scripts de inicialización (como admin)
    if [ -f "${SCRIPTS_DIR}/01_create_schema.sql" ]; then
        run_as_admin "${SCRIPTS_DIR}/01_create_schema.sql" || log_warn "Schema puede ya existir, continuando..."
    fi
    
    # Ejecutar scripts de estructura (como app user)
    for script in $(ls "${SCRIPTS_DIR}"/0[2-9]_*.sql 2>/dev/null | sort); do
        run_as_app "$script" || {
            log_error "Falló: $(basename $script)"
            exit 1
        }
    done
    
    # Ejecutar scripts adicionales (10+)
    for script in $(ls "${SCRIPTS_DIR}"/[1-9][0-9]_*.sql 2>/dev/null | sort); do
        run_as_app "$script" || {
            log_error "Falló: $(basename $script)"
            exit 1
        }
    done
    
    log_info "=========================================="
    log_info "  Deploy completado exitosamente"
    log_info "=========================================="
}

main "$@"
