#!/bin/bash
# ============================================================
# ACME SCHOOL - Ejecución secuencial de TODOS los SQL
# Ejecuta cada script en orden sin pausas.
# Conecta al servidor Oracle via Docker.
# ============================================================

set -e

# ==================== CONFIGURACIÓN ====================
ORACLE_HOST="localhost"
ORACLE_PORT="1521"
ORACLE_SERVICE="FREEPDB1"
ORACLE_SYSTEM_USER="system"
ORACLE_SYSTEM_PASS="AcmeSchool2025lFiXc"
ORACLE_APP_USER="acme_school"
ORACLE_APP_PASS="AcmeSchool2025"

DOCKER_EXEC="docker exec -i acme-school-db"
SQLPLUS_SYSTEM="${DOCKER_EXEC} sqlplus -s ${ORACLE_SYSTEM_USER}/${ORACLE_SYSTEM_PASS}@${ORACLE_SERVICE}"
SQLPLUS_APP="${DOCKER_EXEC} sqlplus -s ${ORACLE_APP_USER}/${ORACLE_APP_PASS}@${ORACLE_SERVICE}"

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# ==================== COLORES ====================
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

run_app() {
    local file="$1"
    echo -e "${GREEN}▶${NC} [APP] $(basename $file)"
    ${SQLPLUS_APP} < "$file" 2>&1 | tail -20
    echo ""
}

run_system() {
    local file="$1"
    echo -e "${CYAN}▶${NC} [SYS] $(basename $file)"
    ${SQLPLUS_SYSTEM} < "$file" 2>&1 | tail -20
    echo ""
}

# ==================== EJECUCIÓN ====================
echo -e "${BOLD}========================================${NC}"
echo -e "${BOLD} ACME SCHOOL - Ejecución Completa${NC}"
echo -e "${BOLD}========================================${NC}"
echo ""

# --- MODELO OPERACIONAL ---
echo -e "${BOLD}--- MODELO OPERACIONAL ---${NC}"
run_app "${BASE_DIR}/sql/oracle/01_create_sequences.sql"
run_app "${BASE_DIR}/sql/oracle/02_create_tables.sql"
run_app "${BASE_DIR}/sql/oracle/03_insert_data.sql"
run_app "${BASE_DIR}/sql/oracle/04_insert_inscripciones_notas.sql"
run_app "${BASE_DIR}/sql/oracle/05_insert_notas.sql"
run_app "${BASE_DIR}/sql/oracle/06_constraints_validation.sql"

# --- PL/SQL ---
echo -e "${BOLD}--- PL/SQL Y TRIGGERS ---${NC}"
run_app "${BASE_DIR}/plsql/functions/fn_promedio_estudiante.sql"
run_app "${BASE_DIR}/plsql/functions/fn_cupo_disponible.sql"
run_app "${BASE_DIR}/plsql/functions/fn_estado_aprobacion.sql"
run_app "${BASE_DIR}/plsql/packages/pkg_inscripciones.sql"
run_app "${BASE_DIR}/plsql/packages/pkg_notas.sql"
run_app "${BASE_DIR}/plsql/triggers/trg_auditoria.sql"
run_app "${BASE_DIR}/plsql/triggers/trg_validacion_negocio.sql"

# --- TRANSACCIONES ---
echo -e "${BOLD}--- TRANSACCIONES ---${NC}"
run_app "${BASE_DIR}/transacciones/01_commit_exitoso.sql"
run_app "${BASE_DIR}/transacciones/02_rollback_error.sql"
run_app "${BASE_DIR}/transacciones/06_deadlock_solucion.sql"

# --- SEGURIDAD ---
echo -e "${BOLD}--- SEGURIDAD ---${NC}"
run_system "${BASE_DIR}/seguridad/01_crear_roles.sql"
run_app "${BASE_DIR}/seguridad/02_grant_revoke.sql"

# --- OPTIMIZACIÓN ---
echo -e "${BOLD}--- OPTIMIZACIÓN ---${NC}"
run_app "${BASE_DIR}/optimizacion/01_consultas_criticas.sql"
run_app "${BASE_DIR}/optimizacion/02_explain_plan_antes.sql"
run_app "${BASE_DIR}/optimizacion/03_crear_indices.sql"
run_app "${BASE_DIR}/optimizacion/04_explain_plan_despues.sql"
run_app "${BASE_DIR}/optimizacion/05_reescritura_sql.sql"

# --- DATA WAREHOUSE ---
echo -e "${BOLD}--- DATA WAREHOUSE ---${NC}"
run_app "${BASE_DIR}/dw/01_modelo_dimensional.sql"
run_app "${BASE_DIR}/dw/02_etl_carga.sql"
run_app "${BASE_DIR}/dw/03_kpis_indicadores.sql"

echo ""
echo -e "${GREEN}✅ Ejecución completa${NC}"
