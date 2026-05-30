#!/bin/bash
# ============================================================
# ACME SCHOOL - Setup completo de la base de datos
# Ejecuta TODOS los .sql del proyecto en orden correcto.
# Después de esto, la BD queda lista para capturar evidencias.
#
# Ejecutar en el servidor donde corre Docker:
#   chmod +x scripts/setup_completo.sh
#   ./scripts/setup_completo.sh
# ============================================================

set -e

# ==================== CONFIGURACIÓN ====================
DOCKER="docker exec -i acme-school-db"
SYSTEM_CONN="system/AcmeSchool2025lFiXc@FREEPDB1"
APP_CONN="acme_school/AcmeSchool2025@FREEPDB1"

# Ruta base (relativa a donde se ejecuta)
BASE="$(cd "$(dirname "$0")/.." && pwd)"

# ==================== FUNCIONES ====================
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

run_system() {
    echo -e "${CYAN}[SYSTEM]${NC} $1"
    echo "$2" | $DOCKER sqlplus -s "$SYSTEM_CONN" 2>&1 | grep -v "^$"
}

run_app() {
    echo -e "${GREEN}[APP]${NC} $1"
    echo "$2" | $DOCKER sqlplus -s "$APP_CONN" 2>&1 | grep -v "^$"
}

run_file_system() {
    echo -e "${CYAN}[SYSTEM]${NC} Ejecutando: $1"
    cat "$BASE/$1" | $DOCKER sqlplus -s "$SYSTEM_CONN" 2>&1 | tail -5
    echo ""
}

run_file_app() {
    echo -e "${GREEN}[APP]${NC} Ejecutando: $1"
    cat "$BASE/$1" | $DOCKER sqlplus -s "$APP_CONN" 2>&1 | tail -5
    echo ""
}

echo "============================================================"
echo " ACME SCHOOL - SETUP COMPLETO"
echo " Servidor: $(hostname)"
echo " Contenedor: acme-school-db"
echo "============================================================"
echo ""

# ============================================================
# FASE 0: Verificar que Oracle está corriendo
# ============================================================
echo "=== FASE 0: Verificando Oracle ==="
if ! docker inspect --format='{{.State.Health.Status}}' acme-school-db 2>/dev/null | grep -q "healthy"; then
    echo -e "${RED}ERROR: Oracle no está healthy. Ejecuta: docker compose up -d${NC}"
    exit 1
fi
echo "Oracle OK."
echo ""

# ============================================================
# FASE 1: Crear schema y usuario acme_school (si no existe)
# ============================================================
echo "=== FASE 1: Schema y usuario ==="
run_system "Creando usuario acme_school" "
WHENEVER SQLERROR CONTINUE
CREATE USER acme_school IDENTIFIED BY AcmeSchool2025
  DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON users;
GRANT CONNECT, RESOURCE TO acme_school;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO acme_school;
GRANT CREATE SEQUENCE, CREATE PROCEDURE, CREATE TRIGGER TO acme_school;
GRANT CREATE TYPE, CREATE SYNONYM, CREATE ROLE TO acme_school;
GRANT CREATE USER, GRANT ANY ROLE, GRANT ANY PRIVILEGE TO acme_school;
GRANT ALTER USER, DROP USER TO acme_school;
GRANT UNLIMITED TABLESPACE TO acme_school;
GRANT SELECT_CATALOG_ROLE TO acme_school;
GRANT CREATE MATERIALIZED VIEW TO acme_school;
PROMPT Usuario acme_school listo.
"
echo ""

# ============================================================
# FASE 2: Modelo operacional (secuencias + tablas + datos)
# ============================================================
echo "=== FASE 2: Modelo operacional ==="
run_file_app "sql/oracle/01_create_sequences.sql"
run_file_app "sql/oracle/02_create_tables.sql"
run_file_app "sql/oracle/03_insert_data.sql"
run_file_app "sql/oracle/04_insert_inscripciones_notas.sql"
run_file_app "sql/oracle/05_insert_notas.sql"

# ============================================================
# FASE 3: PL/SQL (funciones, packages, triggers)
# ============================================================
echo "=== FASE 3: PL/SQL ==="
run_file_app "plsql/functions/fn_promedio_estudiante.sql"
run_file_app "plsql/functions/fn_cupo_disponible.sql"
run_file_app "plsql/functions/fn_estado_aprobacion.sql"
run_file_app "plsql/packages/pkg_inscripciones.sql"
run_file_app "plsql/packages/pkg_notas.sql"
run_file_app "plsql/triggers/trg_auditoria.sql"
run_file_app "plsql/triggers/trg_validacion_negocio.sql"

# ============================================================
# FASE 4: Seguridad (roles + usuarios)
# ============================================================
echo "=== FASE 4: Seguridad ==="
run_system "Creando roles" "
WHENEVER SQLERROR CONTINUE
CREATE ROLE rol_admin_academico;
CREATE ROLE rol_app;
CREATE ROLE rol_docente;
CREATE ROLE rol_auditor;
CREATE ROLE rol_reportes;

GRANT SELECT,INSERT,UPDATE,DELETE ON acme_school.estudiante TO rol_admin_academico;
GRANT SELECT,INSERT,UPDATE,DELETE ON acme_school.docente TO rol_admin_academico;
GRANT SELECT,INSERT,UPDATE,DELETE ON acme_school.curso TO rol_admin_academico;
GRANT SELECT,INSERT,UPDATE,DELETE ON acme_school.periodo TO rol_admin_academico;
GRANT SELECT,INSERT,UPDATE,DELETE ON acme_school.seccion TO rol_admin_academico;
GRANT SELECT,INSERT,UPDATE,DELETE ON acme_school.inscripcion TO rol_admin_academico;
GRANT SELECT,INSERT,UPDATE,DELETE ON acme_school.nota TO rol_admin_academico;
GRANT SELECT ON acme_school.auditoria_academica TO rol_admin_academico;

GRANT SELECT ON acme_school.estudiante TO rol_app;
GRANT SELECT ON acme_school.docente TO rol_app;
GRANT SELECT ON acme_school.curso TO rol_app;
GRANT SELECT ON acme_school.periodo TO rol_app;
GRANT SELECT ON acme_school.seccion TO rol_app;
GRANT SELECT,INSERT,UPDATE ON acme_school.inscripcion TO rol_app;
GRANT SELECT,INSERT,UPDATE ON acme_school.nota TO rol_app;

GRANT SELECT ON acme_school.estudiante TO rol_docente;
GRANT SELECT ON acme_school.curso TO rol_docente;
GRANT SELECT ON acme_school.periodo TO rol_docente;
GRANT SELECT ON acme_school.seccion TO rol_docente;
GRANT SELECT ON acme_school.inscripcion TO rol_docente;
GRANT SELECT,INSERT,UPDATE ON acme_school.nota TO rol_docente;

GRANT SELECT ON acme_school.auditoria_academica TO rol_auditor;
GRANT SELECT ON acme_school.estudiante TO rol_auditor;
GRANT SELECT ON acme_school.inscripcion TO rol_auditor;
GRANT SELECT ON acme_school.nota TO rol_auditor;

GRANT SELECT ON acme_school.estudiante TO rol_reportes;
GRANT SELECT ON acme_school.docente TO rol_reportes;
GRANT SELECT ON acme_school.curso TO rol_reportes;
GRANT SELECT ON acme_school.periodo TO rol_reportes;
GRANT SELECT ON acme_school.seccion TO rol_reportes;
GRANT SELECT ON acme_school.inscripcion TO rol_reportes;
GRANT SELECT ON acme_school.nota TO rol_reportes;
PROMPT Roles y privilegios creados.
"

run_system "Creando usuarios de demo" "
WHENEVER SQLERROR CONTINUE
CREATE USER admin_academico IDENTIFIED BY AdminAcad2025 DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;
CREATE USER app_academica IDENTIFIED BY AppAcad2025 DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;
CREATE USER docente_mendoza IDENTIFIED BY Docente2025 DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;
CREATE USER auditor_sistema IDENTIFIED BY Auditor2025 DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;
CREATE USER analista_bi IDENTIFIED BY Analista2025 DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;
GRANT CREATE SESSION TO admin_academico;
GRANT CREATE SESSION TO app_academica;
GRANT CREATE SESSION TO docente_mendoza;
GRANT CREATE SESSION TO auditor_sistema;
GRANT CREATE SESSION TO analista_bi;
GRANT rol_admin_academico TO admin_academico;
GRANT rol_app TO app_academica;
GRANT rol_docente TO docente_mendoza;
GRANT rol_auditor TO auditor_sistema;
GRANT rol_reportes TO analista_bi;
PROMPT Usuarios de demo creados.
"
echo ""

# ============================================================
# FASE 5: Optimización (índices)
# ============================================================
echo "=== FASE 5: Optimización ==="
run_file_app "optimizacion/03_crear_indices.sql"

# ============================================================
# FASE 6: Data Warehouse (modelo + ETL + KPIs)
# ============================================================
echo "=== FASE 6: Data Warehouse ==="
run_file_app "dw/01_modelo_dimensional.sql"
run_file_app "dw/02_etl_carga.sql"

# ============================================================
# FASE 7: Verificación final
# ============================================================
echo "=== FASE 7: Verificación ==="
run_app "Objetos del schema" "
SET LINESIZE 200
SET PAGESIZE 50
SELECT object_type, COUNT(*) AS cantidad,
       SUM(CASE WHEN status='VALID' THEN 1 ELSE 0 END) AS validos
FROM user_objects
GROUP BY object_type ORDER BY object_type;
"

run_app "Conteo de datos" "
SELECT 'estudiantes' t, COUNT(*) n FROM estudiante UNION ALL
SELECT 'docentes',     COUNT(*) FROM docente    UNION ALL
SELECT 'cursos',       COUNT(*) FROM curso      UNION ALL
SELECT 'periodos',     COUNT(*) FROM periodo    UNION ALL
SELECT 'secciones',    COUNT(*) FROM seccion    UNION ALL
SELECT 'inscripciones',COUNT(*) FROM inscripcion UNION ALL
SELECT 'notas',        COUNT(*) FROM nota       UNION ALL
SELECT 'auditoria',    COUNT(*) FROM auditoria_academica
ORDER BY 1;
"

run_system "Roles y usuarios" "
SET LINESIZE 200
COLUMN grantee FORMAT A20
COLUMN granted_role FORMAT A25
SELECT grantee, granted_role FROM dba_role_privs
WHERE granted_role LIKE 'ROL_%' ORDER BY grantee;
"

echo ""
echo "============================================================"
echo -e " ${GREEN}✅ SETUP COMPLETO${NC}"
echo " La base de datos está lista para capturar evidencias."
echo " Ejecutar: ./evidencias/sprint-2/run_sprint2.sh"
echo "============================================================"
