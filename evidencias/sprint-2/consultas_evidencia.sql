-- ============================================================
-- SPRINT 2 - CONSULTAS PARA CAPTURA DE EVIDENCIA
-- Ejecutar cada bloque en SQL Developer como acme_school
-- (excepto seguridad que usa usuarios específicos)
-- ============================================================

-- ============================================================
-- T-029: Roles creados
-- ============================================================
SELECT role FROM dba_roles WHERE role LIKE 'ROL_%' ORDER BY role;

SELECT grantee, granted_role
FROM dba_role_privs
WHERE granted_role LIKE 'ROL_%'
ORDER BY grantee;

-- ============================================================
-- T-030: GRANT y REVOKE demostración
-- ============================================================
-- Antes: docente no tiene acceso a tabla docente
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';

-- GRANT temporal
GRANT SELECT ON acme_school.docente TO rol_docente;

-- Después de GRANT
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';

-- REVOKE
REVOKE SELECT ON acme_school.docente FROM rol_docente;

-- Después de REVOKE (vacío de nuevo)
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';

-- ============================================================
-- T-031: Acceso no autorizado
-- Conectar como: analista_bi / Analista2025
-- ============================================================
-- En una conexión como analista_bi:
-- SHOW USER;
-- SELECT COUNT(*) FROM acme_school.estudiante;  -- OK
-- INSERT INTO acme_school.estudiante (codigo, nombre, apellido) VALUES ('HACK','X','Y');
-- ERROR: ORA-01031

-- Conectar como: docente_mendoza / Docente2025:
-- SHOW USER;
-- DELETE FROM acme_school.inscripcion WHERE inscripcion_id = 1;
-- ERROR: ORA-01031

-- Conectar como: auditor_sistema / Auditor2025:
-- SHOW USER;
-- UPDATE acme_school.nota SET valor = 100 WHERE nota_id = 1;
-- ERROR: ORA-01031

-- ============================================================
-- T-025: Estrategia de backup (ejecutar en terminal del servidor)
-- docker exec -it acme-school-db rman target /
-- ============================================================
-- SHOW ALL;
-- BACKUP DATABASE;
-- LIST BACKUP SUMMARY;

-- ============================================================
-- T-026: ARCHIVELOG habilitado
-- docker exec -it acme-school-db sqlplus / as sysdba
-- ============================================================
-- SELECT LOG_MODE FROM V$DATABASE;
-- ARCHIVE LOG LIST;

-- ============================================================
-- T-027: Simulación de pérdida (como acme_school)
-- ============================================================
-- Conteo ANTES
SELECT COUNT(*) AS inscripciones_2024_1
FROM inscripcion i
JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = 1;

-- DELETE (ejecutar solo si vas a hacer la demo completa)
-- DELETE FROM nota WHERE inscripcion_id IN (
--     SELECT i.inscripcion_id FROM inscripcion i
--     JOIN seccion s ON i.seccion_id = s.seccion_id WHERE s.periodo_id = 1);
-- DELETE FROM inscripcion WHERE seccion_id IN (
--     SELECT seccion_id FROM seccion WHERE periodo_id = 1);
-- COMMIT;

-- Conteo DESPUÉS (debe ser 0)
-- SELECT COUNT(*) FROM inscripcion i
-- JOIN seccion s ON i.seccion_id = s.seccion_id WHERE s.periodo_id = 1;

-- ============================================================
-- T-028: Recuperación (después de T-027)
-- ============================================================
-- FLASHBACK TABLE nota TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE);
-- FLASHBACK TABLE inscripcion TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE);

-- Verificar recuperación:
-- SELECT COUNT(*) FROM inscripcion i
-- JOIN seccion s ON i.seccion_id = s.seccion_id WHERE s.periodo_id = 1;

-- ============================================================
-- T-033: Consultas críticas (como acme_school)
-- ============================================================
SET TIMING ON;

SELECT p.nombre AS periodo, COUNT(i.inscripcion_id) AS total_inscripciones
FROM periodo p
JOIN seccion s ON p.periodo_id = s.periodo_id
JOIN inscripcion i ON s.seccion_id = i.seccion_id
GROUP BY p.nombre
ORDER BY p.nombre;

SELECT c.nombre AS curso, ROUND(AVG(n.valor), 2) AS promedio, COUNT(n.nota_id) AS total_notas
FROM curso c
JOIN seccion s ON c.curso_id = s.curso_id
JOIN inscripcion i ON s.seccion_id = i.seccion_id
JOIN nota n ON i.inscripcion_id = n.inscripcion_id
GROUP BY c.nombre
ORDER BY promedio DESC;

-- ============================================================
-- T-034: EXPLAIN PLAN antes de índices
-- ============================================================
EXPLAIN PLAN FOR
SELECT e.nombre, e.apellido, c.nombre AS curso, AVG(n.valor) AS promedio
FROM estudiante e
JOIN inscripcion i ON e.estudiante_id = i.estudiante_id
JOIN seccion s ON i.seccion_id = s.seccion_id
JOIN curso c ON s.curso_id = c.curso_id
JOIN nota n ON i.inscripcion_id = n.inscripcion_id
GROUP BY e.nombre, e.apellido, c.nombre;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- ============================================================
-- T-036: Índices creados
-- ============================================================
SELECT index_name, table_name, column_name
FROM user_ind_columns
WHERE index_name LIKE 'IDX_%'
ORDER BY index_name;

-- ============================================================
-- T-037: EXPLAIN PLAN después de índices
-- ============================================================
EXPLAIN PLAN FOR
SELECT e.nombre, e.apellido, c.nombre AS curso, AVG(n.valor) AS promedio
FROM estudiante e
JOIN inscripcion i ON e.estudiante_id = i.estudiante_id
JOIN seccion s ON i.seccion_id = s.seccion_id
JOIN curso c ON s.curso_id = c.curso_id
JOIN nota n ON i.inscripcion_id = n.inscripcion_id
GROUP BY e.nombre, e.apellido, c.nombre;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- ============================================================
-- T-039: Modelo dimensional DW (tablas creadas)
-- ============================================================
SELECT table_name FROM user_tables WHERE table_name LIKE 'DW_%' ORDER BY table_name;

-- ============================================================
-- T-041: ETL ejecutado (datos en DW)
-- ============================================================
SELECT 'dw_dim_estudiante' AS tabla, COUNT(*) AS total FROM dw_dim_estudiante UNION ALL
SELECT 'dw_dim_curso',      COUNT(*) FROM dw_dim_curso      UNION ALL
SELECT 'dw_dim_docente',    COUNT(*) FROM dw_dim_docente    UNION ALL
SELECT 'dw_dim_periodo',    COUNT(*) FROM dw_dim_periodo    UNION ALL
SELECT 'dw_fact_inscripciones', COUNT(*) FROM dw_fact_inscripciones UNION ALL
SELECT 'dw_fact_notas',     COUNT(*) FROM dw_fact_notas
ORDER BY tabla;

-- ============================================================
-- T-042: KPIs estratégicos
-- ============================================================
-- KPI 1: Tasa de aprobación por curso
SELECT c.nombre AS curso,
       COUNT(*) AS evaluados,
       SUM(CASE WHEN f.aprobado = 1 THEN 1 ELSE 0 END) AS aprobados,
       ROUND(SUM(CASE WHEN f.aprobado = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS tasa_aprobacion
FROM dw_fact_notas f
JOIN dw_dim_curso c ON f.curso_key = c.curso_key
GROUP BY c.nombre
ORDER BY tasa_aprobacion DESC;

-- KPI 2: Promedio por docente
SELECT d.nombre_completo AS docente,
       ROUND(AVG(f.promedio_nota), 2) AS promedio_general
FROM dw_fact_notas f
JOIN dw_dim_docente d ON f.docente_key = d.docente_key
GROUP BY d.nombre_completo
ORDER BY promedio_general DESC;

-- KPI 3: Inscripciones por período
SELECT p.nombre AS periodo,
       COUNT(*) AS total_inscripciones
FROM dw_fact_inscripciones f
JOIN dw_dim_periodo p ON f.periodo_key = p.periodo_key
GROUP BY p.nombre
ORDER BY p.nombre;
