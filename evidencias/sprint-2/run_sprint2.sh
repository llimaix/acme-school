#!/bin/zsh
# ============================================================
# SPRINT 2 - Ejecución completa de evidencias desde terminal
# Conecta al servidor Oracle via Docker y ejecuta todo
# secuencialmente, mostrando resultados completos.
# ============================================================

# ==================== CONFIGURACIÓN ====================
DOCKER="docker exec -i acme-school-db"
SYSTEM_CONN="system/AcmeSchool2025lFiXc@FREEPDB1"
APP_CONN="acme_school/AcmeSchool2025@FREEPDB1"

# Usuarios de seguridad (creados en T-029)
ANALISTA_CONN="analista_bi/Analista2025@FREEPDB1"
DOCENTE_CONN="docente_mendoza/Docente2025@FREEPDB1"
AUDITOR_CONN="auditor_sistema/Auditor2025@FREEPDB1"
APPADM_CONN="app_academica/AppAcad2025@FREEPDB1"

# ==================== FUNCIONES ====================
run_sql() {
    local CONN="$1"
    local LABEL="$2"
    local SQL="$3"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📌 $LABEL"
    echo "   Conexión: $(echo $CONN | cut -d/ -f1)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "$SQL" | $DOCKER sqlplus -s "$CONN"
    echo ""
}

separator() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  $1"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

# ==================== EJECUCIÓN ====================

separator "SPRINT 2 - EVIDENCIAS COMPLETAS"

# ============================================================
# T-029: ROLES Y USUARIOS
# ============================================================
separator "T-029: ROLES Y USUARIOS CREADOS"

run_sql "$SYSTEM_CONN" "Roles del proyecto" "
SET LINESIZE 200
SET PAGESIZE 50
COLUMN role FORMAT A25
SELECT role FROM dba_roles WHERE role LIKE 'ROL_%' ORDER BY role;
"

run_sql "$SYSTEM_CONN" "Usuarios y roles asignados" "
SET LINESIZE 200
SET PAGESIZE 50
COLUMN grantee FORMAT A20
COLUMN granted_role FORMAT A25
SELECT grantee, granted_role
FROM dba_role_privs
WHERE granted_role LIKE 'ROL_%'
ORDER BY grantee;
"

run_sql "$SYSTEM_CONN" "Privilegios por rol" "
SET LINESIZE 200
SET PAGESIZE 100
COLUMN role FORMAT A22
COLUMN privilege FORMAT A10
COLUMN table_name FORMAT A25
SELECT role, privilege, owner || '.' || table_name AS objeto
FROM role_tab_privs
WHERE role LIKE 'ROL_%'
ORDER BY role, table_name, privilege;
"

# ============================================================
# T-030: GRANT Y REVOKE
# ============================================================
separator "T-030: DEMOSTRACIÓN GRANT Y REVOKE"

run_sql "$APP_CONN" "ANTES: privilegios de rol_docente sobre DOCENTE" "
SET LINESIZE 200
COLUMN privilege FORMAT A15
COLUMN table_name FORMAT A20
SELECT privilege, table_name FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';
PROMPT (vacío = no tiene acceso)
"

run_sql "$APP_CONN" "GRANT SELECT a rol_docente" "
GRANT SELECT ON acme_school.docente TO rol_docente;
PROMPT GRANT ejecutado.
SELECT privilege, table_name FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';
"

run_sql "$APP_CONN" "REVOKE SELECT de rol_docente" "
REVOKE SELECT ON acme_school.docente FROM rol_docente;
PROMPT REVOKE ejecutado.
SELECT privilege, table_name FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';
PROMPT (vacío de nuevo = REVOKE funcionó)
"

# ============================================================
# T-031: ACCESO NO AUTORIZADO
# ============================================================
separator "T-031: INTENTOS DE ACCESO NO AUTORIZADO"

run_sql "$ANALISTA_CONN" "analista_bi: SELECT permitido" "
SHOW USER
SELECT COUNT(*) AS total_estudiantes FROM acme_school.estudiante;
"

run_sql "$ANALISTA_CONN" "analista_bi: INSERT denegado (ORA-01031)" "
SHOW USER
INSERT INTO acme_school.estudiante (codigo, nombre, apellido) VALUES ('HACK','X','Y');
"

run_sql "$DOCENTE_CONN" "docente_mendoza: SELECT nota permitido" "
SHOW USER
SELECT COUNT(*) AS total_notas FROM acme_school.nota;
"

run_sql "$DOCENTE_CONN" "docente_mendoza: DELETE denegado (ORA-01031)" "
SHOW USER
DELETE FROM acme_school.inscripcion WHERE inscripcion_id = 1;
"

run_sql "$DOCENTE_CONN" "docente_mendoza: DROP TABLE denegado (ORA-01031)" "
SHOW USER
DROP TABLE acme_school.estudiante;
"

run_sql "$AUDITOR_CONN" "auditor_sistema: SELECT auditoria permitido" "
SHOW USER
SELECT COUNT(*) AS registros_auditoria FROM acme_school.auditoria_academica;
"

run_sql "$AUDITOR_CONN" "auditor_sistema: UPDATE nota denegado (ORA-01031)" "
SHOW USER
UPDATE acme_school.nota SET valor = 100 WHERE nota_id = 1;
"

run_sql "$APPADM_CONN" "app_academica: SELECT auditoria denegado (ORA-00942)" "
SHOW USER
SELECT * FROM acme_school.auditoria_academica WHERE ROWNUM = 1;
"

# ============================================================
# T-025/T-026: BACKUP Y ARCHIVELOG
# ============================================================
separator "T-025/T-026: BACKUP Y ARCHIVELOG"

run_sql "$SYSTEM_CONN" "T-026: Modo de la base de datos" "
SELECT LOG_MODE FROM V\$DATABASE;
"

echo "📌 T-025: Configuración RMAN"
echo "   (ejecutar manualmente: docker exec -it acme-school-db rman target /)"
echo "   Comandos: SHOW ALL; BACKUP DATABASE; LIST BACKUP SUMMARY;"
echo ""

# ============================================================
# T-027/T-028: SIMULACIÓN PÉRDIDA Y RECUPERACIÓN
# ============================================================
separator "T-027: SIMULACIÓN DE PÉRDIDA"

run_sql "$APP_CONN" "Conteo ANTES de la pérdida" "
SET LINESIZE 200
SELECT 'inscripciones_2024_1' AS dato, COUNT(*) AS total
FROM inscripcion i JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = 1
UNION ALL
SELECT 'notas_2024_1', COUNT(*)
FROM nota n JOIN inscripcion i ON n.inscripcion_id = i.inscripcion_id
JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = 1;
"

run_sql "$APP_CONN" "Ejecutando DELETE (simulación de pérdida)" "
DELETE FROM nota WHERE inscripcion_id IN (
    SELECT i.inscripcion_id FROM inscripcion i
    JOIN seccion s ON i.seccion_id = s.seccion_id WHERE s.periodo_id = 1);
DELETE FROM inscripcion WHERE seccion_id IN (
    SELECT seccion_id FROM seccion WHERE periodo_id = 1);
COMMIT;
PROMPT Datos eliminados (pérdida simulada).
"

run_sql "$APP_CONN" "Conteo DESPUÉS de la pérdida (debe ser 0)" "
SELECT 'inscripciones_2024_1' AS dato, COUNT(*) AS total
FROM inscripcion i JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = 1
UNION ALL
SELECT 'notas_2024_1', COUNT(*)
FROM nota n JOIN inscripcion i ON n.inscripcion_id = i.inscripcion_id
JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = 1;
"

separator "T-028: RECUPERACIÓN"

run_sql "$APP_CONN" "Recuperando con FLASHBACK TABLE" "
ALTER TABLE nota ENABLE ROW MOVEMENT;
ALTER TABLE inscripcion ENABLE ROW MOVEMENT;
FLASHBACK TABLE nota TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '2' MINUTE);
FLASHBACK TABLE inscripcion TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '2' MINUTE);
PROMPT Flashback ejecutado.
"

run_sql "$APP_CONN" "Conteo DESPUÉS de recuperación (debe coincidir con ANTES)" "
SELECT 'inscripciones_2024_1' AS dato, COUNT(*) AS total
FROM inscripcion i JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = 1
UNION ALL
SELECT 'notas_2024_1', COUNT(*)
FROM nota n JOIN inscripcion i ON n.inscripcion_id = i.inscripcion_id
JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = 1;
"

# ============================================================
# T-033 a T-037: OPTIMIZACIÓN
# ============================================================
separator "T-033/T-034: CONSULTAS CRÍTICAS + EXPLAIN PLAN ANTES"

run_sql "$APP_CONN" "Consulta crítica: inscripciones por período" "
SET TIMING ON
SET LINESIZE 200
COLUMN periodo FORMAT A25
SELECT p.nombre AS periodo, COUNT(i.inscripcion_id) AS total_inscripciones
FROM periodo p
JOIN seccion s ON p.periodo_id = s.periodo_id
JOIN inscripcion i ON s.seccion_id = i.seccion_id
GROUP BY p.nombre ORDER BY p.nombre;
"

run_sql "$APP_CONN" "Consulta crítica: promedio por curso" "
SET TIMING ON
SET LINESIZE 200
COLUMN curso FORMAT A30
SELECT c.nombre AS curso, ROUND(AVG(n.valor),2) AS promedio, COUNT(n.nota_id) AS notas
FROM curso c
JOIN seccion s ON c.curso_id = s.curso_id
JOIN inscripcion i ON s.seccion_id = i.seccion_id
JOIN nota n ON i.inscripcion_id = n.inscripcion_id
GROUP BY c.nombre ORDER BY promedio DESC;
"

run_sql "$APP_CONN" "EXPLAIN PLAN antes de índices" "
SET LINESIZE 200
SET PAGESIZE 100
EXPLAIN PLAN FOR
SELECT e.nombre, e.apellido, c.nombre AS curso, AVG(n.valor) AS promedio
FROM estudiante e
JOIN inscripcion i ON e.estudiante_id = i.estudiante_id
JOIN seccion s ON i.seccion_id = s.seccion_id
JOIN curso c ON s.curso_id = c.curso_id
JOIN nota n ON i.inscripcion_id = n.inscripcion_id
GROUP BY e.nombre, e.apellido, c.nombre;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
"

separator "T-036: ÍNDICES CREADOS"

run_sql "$APP_CONN" "Índices del proyecto" "
SET LINESIZE 200
COLUMN index_name FORMAT A30
COLUMN table_name FORMAT A20
COLUMN column_name FORMAT A20
SELECT index_name, table_name, column_name
FROM user_ind_columns
WHERE index_name LIKE 'IDX_%'
ORDER BY index_name;
"

separator "T-037: EXPLAIN PLAN DESPUÉS DE ÍNDICES"

run_sql "$APP_CONN" "EXPLAIN PLAN después de índices" "
SET LINESIZE 200
SET PAGESIZE 100
EXPLAIN PLAN FOR
SELECT e.nombre, e.apellido, c.nombre AS curso, AVG(n.valor) AS promedio
FROM estudiante e
JOIN inscripcion i ON e.estudiante_id = i.estudiante_id
JOIN seccion s ON i.seccion_id = s.seccion_id
JOIN curso c ON s.curso_id = c.curso_id
JOIN nota n ON i.inscripcion_id = n.inscripcion_id
GROUP BY e.nombre, e.apellido, c.nombre;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
"

# ============================================================
# T-039 a T-042: DATA WAREHOUSE
# ============================================================
separator "T-039/T-041: MODELO DIMENSIONAL + ETL"

run_sql "$APP_CONN" "Tablas DW creadas" "
SET LINESIZE 200
COLUMN table_name FORMAT A30
SELECT table_name FROM user_tables WHERE table_name LIKE 'DW_%' ORDER BY table_name;
"

run_sql "$APP_CONN" "Datos cargados en DW (post ETL)" "
SET LINESIZE 200
SELECT 'dw_dim_estudiante' AS tabla, COUNT(*) AS total FROM dw_dim_estudiante UNION ALL
SELECT 'dw_dim_curso',      COUNT(*) FROM dw_dim_curso      UNION ALL
SELECT 'dw_dim_docente',    COUNT(*) FROM dw_dim_docente    UNION ALL
SELECT 'dw_dim_periodo',    COUNT(*) FROM dw_dim_periodo    UNION ALL
SELECT 'dw_fact_inscripciones', COUNT(*) FROM dw_fact_inscripciones UNION ALL
SELECT 'dw_fact_notas',     COUNT(*) FROM dw_fact_notas
ORDER BY tabla;
"

separator "T-042: KPIs ESTRATÉGICOS"

run_sql "$APP_CONN" "KPI 1: Tasa de aprobación por curso" "
SET LINESIZE 200
COLUMN curso FORMAT A30
SELECT c.nombre AS curso,
       COUNT(*) AS evaluados,
       SUM(CASE WHEN f.aprobado = 1 THEN 1 ELSE 0 END) AS aprobados,
       ROUND(SUM(CASE WHEN f.aprobado = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS tasa_aprobacion_pct
FROM dw_fact_notas f
JOIN dw_dim_curso c ON f.curso_key = c.curso_key
GROUP BY c.nombre ORDER BY tasa_aprobacion_pct DESC;
"

run_sql "$APP_CONN" "KPI 2: Promedio por docente" "
SET LINESIZE 200
COLUMN docente FORMAT A30
SELECT d.nombre_completo AS docente,
       ROUND(AVG(f.promedio_nota), 2) AS promedio_general
FROM dw_fact_notas f
JOIN dw_dim_docente d ON f.docente_key = d.docente_key
GROUP BY d.nombre_completo ORDER BY promedio_general DESC;
"

run_sql "$APP_CONN" "KPI 3: Inscripciones por período" "
SET LINESIZE 200
COLUMN periodo FORMAT A30
SELECT p.nombre AS periodo, COUNT(*) AS total_inscripciones
FROM dw_fact_inscripciones f
JOIN dw_dim_periodo p ON f.periodo_key = p.periodo_key
GROUP BY p.nombre ORDER BY p.nombre;
"

# ============================================================
separator "✅ SPRINT 2 COMPLETO"
echo "Todas las evidencias ejecutadas."
echo "Toma capturas de la terminal completa."
