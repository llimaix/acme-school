#!/bin/bash
# ============================================================
# ACME SCHOOL - Script de ejecución secuencial para evidencias
# Ejecuta cada SQL del proyecto en orden, pausando entre cada
# uno para que captures la evidencia en SQL Developer.
#
# Uso:
#   chmod +x scripts/run_evidencias.sh
#   ./scripts/run_evidencias.sh
#
# Prerrequisitos:
#   - Oracle corriendo en el servidor (docker compose up -d)
#   - SQL Developer conectado al mismo servidor
#   - Acceso SSH al servidor o sqlplus local con TNS configurado
# ============================================================

set -e

# ==================== CONFIGURACIÓN ====================
# Ajustar estos valores según tu servidor

ORACLE_HOST="localhost"
ORACLE_PORT="1521"
ORACLE_SERVICE="FREEPDB1"
ORACLE_SYSTEM_USER="system"
ORACLE_SYSTEM_PASS="AcmeSchool2025lFiXc"
ORACLE_APP_USER="acme_admin"
ORACLE_APP_PASS="AcmeSchool2025"

# Conexión via Docker (si ejecutas desde el servidor)
DOCKER_EXEC="docker exec -i acme-school-db"
SQLPLUS_SYSTEM="${DOCKER_EXEC} sqlplus -s ${ORACLE_SYSTEM_USER}/${ORACLE_SYSTEM_PASS}@${ORACLE_SERVICE}"
SQLPLUS_APP="${DOCKER_EXEC} sqlplus -s ${ORACLE_APP_USER}/${ORACLE_APP_PASS}@${ORACLE_SERVICE}"

# Directorio base del proyecto
BASE_DIR="$(dirname "$0")/.."

# ==================== COLORES ====================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ==================== FUNCIONES ====================

banner() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} ${BOLD}$1${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

step() {
    echo -e "${GREEN}▶${NC} ${BOLD}$1${NC}"
}

info() {
    echo -e "${CYAN}  ℹ${NC} $1"
}

warn() {
    echo -e "${YELLOW}  ⚠${NC} $1"
}

pause_for_evidence() {
    local task_id="$1"
    local description="$2"
    local evidence_folder="$3"
    
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  📸 CAPTURA DE EVIDENCIA${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  Tarea: ${BOLD}${task_id}${NC}"
    echo -e "  Qué capturar: ${description}"
    echo -e "  Guardar en: ${CYAN}evidencias/${evidence_folder}/${task_id}.png${NC}"
    echo ""
    echo -e "  Abre ${BOLD}SQL Developer${NC} y ejecuta el mismo script para ver"
    echo -e "  los resultados de forma visual. Toma la captura."
    echo ""
    echo -e "${YELLOW}  Escribe 'next' para continuar al siguiente paso...${NC}"
    echo ""
    
    while true; do
        read -p "  > " input
        if [ "$input" = "next" ] || [ "$input" = "n" ] || [ "$input" = "" ]; then
            break
        fi
        echo "  Escribe 'next' para continuar"
    done
    echo ""
}

run_sql_system() {
    local file="$1"
    step "Ejecutando como SYSTEM: $(basename $file)"
    ${SQLPLUS_SYSTEM} < "$file" 2>&1 | head -100
}

run_sql_app() {
    local file="$1"
    step "Ejecutando como ${ORACLE_APP_USER}: $(basename $file)"
    ${SQLPLUS_APP} < "$file" 2>&1 | head -100
}

# ==================== INICIO ====================

clear
banner "ACME SCHOOL - Ejecución Secuencial de Evidencias"
echo -e "  Este script ejecuta cada componente del proyecto en orden."
echo -e "  Después de cada ejecución, pausa para que captures la evidencia"
echo -e "  en SQL Developer y la guardes en la carpeta correspondiente."
echo ""
echo -e "  Servidor: ${BOLD}${ORACLE_HOST}:${ORACLE_PORT}/${ORACLE_SERVICE}${NC}"
echo -e "  System:   ${BOLD}${ORACLE_SYSTEM_USER}${NC}"
echo -e "  App:      ${BOLD}${ORACLE_APP_USER}${NC}"
echo ""
echo -e "  Presiona Enter para comenzar..."
read

# ============================================================
# SPRINT 1: MODELO OPERACIONAL
# ============================================================

banner "SPRINT 1 - MODELO OPERACIONAL (Wuili)"

# T-008: Secuencias
step "[T-008] Creando secuencias..."
run_sql_app "${BASE_DIR}/sql/oracle/01_create_sequences.sql"
pause_for_evidence "T-008a" "Captura de secuencias creadas (SELECT * FROM user_sequences)" "sprint-1"

# T-008: Tablas
step "[T-008] Creando tablas del modelo operacional..."
run_sql_app "${BASE_DIR}/sql/oracle/02_create_tables.sql"
pause_for_evidence "T-008b" "Captura de tablas creadas (SELECT table_name FROM user_tables) y constraints" "sprint-1"

# T-009: Datos de prueba
step "[T-009] Insertando datos de prueba..."
if [ -f "${BASE_DIR}/sql/oracle/03_insert_data.sql" ]; then
    run_sql_app "${BASE_DIR}/sql/oracle/03_insert_data.sql"
fi
pause_for_evidence "T-009" "Captura de conteos por tabla (SELECT COUNT(*) FROM ...)" "sprint-1"

# T-010: Validación de constraints
step "[T-010] Probando integridad referencial..."
if [ -f "${BASE_DIR}/database/scripts_prueba_integridad.sql" ]; then
    run_sql_app "${BASE_DIR}/database/scripts_prueba_integridad.sql"
fi
pause_for_evidence "T-010" "Captura de errores ORA controlados (FK, UNIQUE, CHECK)" "sprint-1"

# ============================================================
# SPRINT 1: PL/SQL Y TRIGGERS (Emmanuel)
# ============================================================

banner "SPRINT 1 - PL/SQL Y TRIGGERS (Emmanuel)"

# T-011: pkg_inscripciones
step "[T-011] Creando package pkg_inscripciones..."
run_sql_app "${BASE_DIR}/plsql/packages/pkg_inscripciones.sql"
pause_for_evidence "T-011" "Captura del package compilado sin errores + prueba de inscribir_estudiante" "sprint-1"

# T-018: pkg_notas
step "[T-018] Creando package pkg_notas..."
run_sql_app "${BASE_DIR}/plsql/packages/pkg_notas.sql"
pause_for_evidence "T-018" "Captura del package compilado + prueba de registrar_nota" "sprint-1"

# T-019: Funciones
step "[T-019] Creando funciones PL/SQL..."
run_sql_app "${BASE_DIR}/plsql/functions/fn_promedio_estudiante.sql"
run_sql_app "${BASE_DIR}/plsql/functions/fn_cupo_disponible.sql"
run_sql_app "${BASE_DIR}/plsql/functions/fn_estado_aprobacion.sql"
pause_for_evidence "T-019" "Captura de SELECT fn_promedio_estudiante(1), fn_cupo_disponible(11), fn_estado_aprobacion(1) FROM DUAL" "sprint-1"

# T-021: Trigger auditoría
step "[T-021] Creando trigger de auditoría..."
run_sql_app "${BASE_DIR}/plsql/triggers/trg_auditoria.sql"
pause_for_evidence "T-021" "Captura del trigger creado + INSERT de prueba + SELECT de auditoria_academica" "sprint-1"

# T-022: Trigger validación
step "[T-022] Creando trigger de validación..."
run_sql_app "${BASE_DIR}/plsql/triggers/trg_validacion_negocio.sql"
pause_for_evidence "T-022" "Captura de INSERT con nota=150 (debe fallar con RAISE_APPLICATION_ERROR)" "sprint-1"

# ============================================================
# SPRINT 1: TRANSACCIONES (Wuili)
# ============================================================

banner "SPRINT 1 - TRANSACCIONES Y CONCURRENCIA (Wuili)"

# T-012: COMMIT exitoso
step "[T-012] Demostración de COMMIT exitoso..."
run_sql_app "${BASE_DIR}/transacciones/01_commit_exitoso.sql"
pause_for_evidence "T-012" "Captura de estado ANTES, la transacción, y estado DESPUÉS con datos persistidos" "sprint-1"

# T-013: ROLLBACK
step "[T-013] Demostración de ROLLBACK ante error..."
run_sql_app "${BASE_DIR}/transacciones/02_rollback_error.sql"
pause_for_evidence "T-013" "Captura de los 3 escenarios (cupo lleno, duplicado, período cerrado) con ROLLBACK" "sprint-1"

# T-014: READ COMMITTED
step "[T-014] Aislamiento READ COMMITTED..."
info "Este requiere DOS sesiones en SQL Developer."
info "Abre dos conexiones y sigue los pasos del script."
warn "Archivo: transacciones/03_read_committed.sql"
pause_for_evidence "T-014" "Captura de Sesión A (UPDATE sin COMMIT) y Sesión B (no ve cambios) y después de COMMIT (sí los ve)" "sprint-1"

# T-015: SERIALIZABLE
step "[T-015] Aislamiento SERIALIZABLE..."
info "Este requiere DOS sesiones en SQL Developer."
info "Abre dos conexiones y sigue los pasos del script."
warn "Archivo: transacciones/04_serializable.sql"
pause_for_evidence "T-015" "Captura de ORA-08177 (cannot serialize access) cuando Sesión A intenta UPDATE" "sprint-1"

# T-016: Deadlock
step "[T-016] Reproducción de deadlock ORA-00060..."
info "Este requiere DOS sesiones en SQL Developer."
info "Sigue los pasos del script en orden."
warn "Archivo: transacciones/05_deadlock_escenario.sql"
pause_for_evidence "T-016" "Captura de ORA-00060 (deadlock detected while waiting for resource)" "sprint-1"

# T-017: Solución deadlock
step "[T-017] Solución del deadlock..."
run_sql_app "${BASE_DIR}/transacciones/06_deadlock_solucion.sql"
pause_for_evidence "T-017" "Captura del procedimiento con orden fijo de locks + ejecución sin deadlock" "sprint-1"

# ============================================================
# SPRINT 2: SEGURIDAD (Luis)
# ============================================================

banner "SPRINT 2 - SEGURIDAD Y ROLES (Luis)"

# T-029: Crear roles
step "[T-029] Creando roles y usuarios..."
run_sql_system "${BASE_DIR}/seguridad/01_crear_roles.sql"
pause_for_evidence "T-029" "Captura de roles creados (SELECT role FROM dba_roles WHERE role LIKE 'ROL_%') y usuarios asignados" "sprint-2"

# T-030: GRANT/REVOKE
step "[T-030] Demostración de GRANT y REVOKE..."
run_sql_app "${BASE_DIR}/seguridad/02_grant_revoke.sql"
pause_for_evidence "T-030" "Captura de privilegios antes/después de GRANT y después de REVOKE" "sprint-2"

# T-031: Acceso no autorizado
step "[T-031] Intentos de acceso no autorizado..."
info "Conectar como cada usuario en SQL Developer y ejecutar las operaciones."
info "Usuarios: analista_bi, docente_mendoza, auditor_sistema, app_academica"
warn "Archivo: seguridad/03_acceso_no_autorizado.sql"
pause_for_evidence "T-031" "Captura de SHOW USER + error ORA-01031 para cada intento denegado" "sprint-2"

# ============================================================
# SPRINT 2: BACKUP Y RECUPERACIÓN (Luis)
# ============================================================

banner "SPRINT 2 - BACKUP Y RECUPERACIÓN (Luis)"

# T-025: Estrategia
step "[T-025] Configurando estrategia de backup RMAN..."
info "Ejecutar los comandos RMAN dentro del contenedor:"
info "  docker exec -it acme-school-db rman target /"
warn "Archivo: backup/01_estrategia_backup.sql"
pause_for_evidence "T-025" "Captura de SHOW ALL en RMAN + BACKUP DATABASE exitoso" "sprint-2"

# T-026: ARCHIVELOG
step "[T-026] Habilitando ARCHIVELOG..."
info "Ejecutar como SYSDBA dentro del contenedor:"
info "  docker exec -it acme-school-db sqlplus / as sysdba"
warn "Archivo: backup/02_archivelog_config.sql"
pause_for_evidence "T-026" "Captura de SELECT log_mode FROM v\$database (ARCHIVELOG) + ARCHIVE LOG LIST" "sprint-2"

# T-027: Simulación pérdida
step "[T-027] Simulando pérdida de datos..."
info "IMPORTANTE: Asegúrate de tener backup antes de ejecutar."
run_sql_app "${BASE_DIR}/backup/03_simulacion_perdida.sql"
pause_for_evidence "T-027" "Captura de conteos ANTES (>0) y DESPUÉS (=0) del DELETE" "sprint-2"

# T-028: Recuperación
step "[T-028] Recuperando datos..."
run_sql_app "${BASE_DIR}/backup/04_recuperacion.sql"
pause_for_evidence "T-028" "Captura de datos recuperados (conteos iguales a los originales)" "sprint-2"

# ============================================================
# SPRINT 2: OPTIMIZACIÓN (Julian)
# ============================================================

banner "SPRINT 2 - OPTIMIZACIÓN Y RENDIMIENTO (Julian)"

# T-033/T-034: Consultas + EXPLAIN PLAN antes
step "[T-033/T-034] Consultas críticas + EXPLAIN PLAN antes de optimizar..."
run_sql_app "${BASE_DIR}/optimizacion/01_consultas_criticas.sql"
run_sql_app "${BASE_DIR}/optimizacion/02_explain_plan_antes.sql"
pause_for_evidence "T-034" "Captura de EXPLAIN PLAN con TABLE ACCESS FULL y costos altos" "sprint-2"

# T-036: Índices
step "[T-036] Creando índices estratégicos..."
run_sql_app "${BASE_DIR}/optimizacion/03_crear_indices.sql"
pause_for_evidence "T-036" "Captura de índices creados (SELECT index_name FROM user_indexes)" "sprint-2"

# T-037: EXPLAIN PLAN después
step "[T-037] EXPLAIN PLAN después de optimizar..."
run_sql_app "${BASE_DIR}/optimizacion/04_explain_plan_despues.sql"
pause_for_evidence "T-037" "Captura de EXPLAIN PLAN con INDEX SCAN y costos reducidos. Tabla comparativa." "sprint-2"

# T-038: Reescritura SQL
step "[T-038] Reescritura de consulta SQL..."
run_sql_app "${BASE_DIR}/optimizacion/05_reescritura_sql.sql"
pause_for_evidence "T-038" "Captura de consulta original vs optimizada con mejora de rendimiento" "sprint-2"

# ============================================================
# SPRINT 2: DATA WAREHOUSE (Julian)
# ============================================================

banner "SPRINT 2 - DATA WAREHOUSE Y BI (Julian)"

# T-039/T-040: Modelo dimensional
step "[T-039/T-040] Creando modelo dimensional del DW..."
run_sql_app "${BASE_DIR}/dw/01_modelo_dimensional.sql"
pause_for_evidence "T-039" "Captura de tablas DW creadas (dim_*, fact_*)" "sprint-2"

# T-041: ETL
step "[T-041] Ejecutando proceso ETL..."
run_sql_app "${BASE_DIR}/dw/02_etl_carga.sql"
pause_for_evidence "T-041" "Captura de datos cargados en dimensiones y hechos" "sprint-2"

# T-042/T-043: KPIs
step "[T-042/T-043] Ejecutando consultas de KPIs..."
run_sql_app "${BASE_DIR}/dw/03_kpis_indicadores.sql"
pause_for_evidence "T-042" "Captura de los 3+ KPIs: tasa aprobación, promedio por curso, inscripciones por período" "sprint-2"

# ============================================================
# SPRINT 3: ALTA DISPONIBILIDAD (Luis)
# ============================================================

banner "SPRINT 3 - ALTA DISPONIBILIDAD (Luis)"

step "[T-045] Arquitectura HA..."
info "El diagrama está en: ha/01_arquitectura_ha.md"
info "Renderízalo en GitHub o exporta el Mermaid como imagen."
pause_for_evidence "T-045" "Captura del diagrama HA renderizado (Mermaid o draw.io)" "sprint-3"

step "[T-046] RPO y RTO..."
info "Documentado en: ha/03_rpo_rto.md"
pause_for_evidence "T-046" "Captura de la tabla de RPO/RTO y proceso de failover" "sprint-3"

step "[T-047] Simulación de failover..."
info "Seguir los pasos de: ha/02_failover_simulacion.sql"
info "Requiere levantar un segundo contenedor Docker."
pause_for_evidence "T-047" "Captura de datos disponibles en el standby después del failover" "sprint-3"

# ============================================================
# FIN
# ============================================================

banner "¡EJECUCIÓN COMPLETA!"
echo -e "  Todas las tareas fueron ejecutadas."
echo ""
echo -e "  ${BOLD}Próximo paso:${NC}"
echo -e "  Consolidar todas las capturas de ${CYAN}evidencias/${NC} en el PDF final (T-050)."
echo ""
echo -e "  Archivos de evidencia esperados en:"
echo -e "    evidencias/sprint-1/ → Modelo, PL/SQL, Transacciones"
echo -e "    evidencias/sprint-2/ → Seguridad, Backup, Optimización, DW"
echo -e "    evidencias/sprint-3/ → HA, Presentación"
echo ""
echo -e "${GREEN}  ✅ Listo para armar el PDF${NC}"
echo ""
