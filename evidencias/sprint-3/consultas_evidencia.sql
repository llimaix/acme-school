-- ============================================================
-- SPRINT 3 - CONSULTAS PARA CAPTURA DE EVIDENCIA
-- Alta Disponibilidad + verificación general
-- ============================================================

-- ============================================================
-- T-045: Diagrama de Arquitectura HA
-- No es SQL. Capturar el diagrama renderizado de:
--   ha/01_arquitectura_ha.md
-- Abrir en GitHub (renderiza Mermaid) o exportar desde
-- https://mermaid.live/ pegando el bloque ```mermaid
-- ============================================================

-- ============================================================
-- T-046: RPO y RTO
-- No es SQL. Capturar la tabla de RPO/RTO de:
--   ha/03_rpo_rto.md
-- ============================================================

-- ============================================================
-- T-047: Simulación de failover
-- Ejecutar en terminal del servidor:
-- ============================================================

-- Paso 1: Export del primario
-- docker exec acme-school-db bash -c "
--   expdp system/AcmeSchool2025lFiXc@FREEPDB1 \
--     DIRECTORY=DATA_PUMP_DIR \
--     DUMPFILE=failover_test.dmp \
--     SCHEMAS=acme_school"

-- Paso 2: Levantar standby
-- docker run -d --name acme-school-standby \
--   -p 1522:1521 \
--   -e ORACLE_PASSWORD=AcmeSchool2025lFiXc \
--   gvenzl/oracle-free:23-full

-- Paso 3: Importar en standby
-- (esperar que esté healthy, luego impdp)

-- Paso 4: Verificar datos en standby (conectar al puerto 1522)
-- SELECT 'estudiantes' AS tabla, COUNT(*) AS total FROM estudiante UNION ALL
-- SELECT 'inscripciones', COUNT(*) FROM inscripcion UNION ALL
-- SELECT 'notas', COUNT(*) FROM nota;

-- Paso 5: Simular caída
-- docker stop acme-school-db

-- Paso 6: Confirmar que standby sigue operativo
-- (conectar al 1522 y ejecutar una operación)

-- ============================================================
-- VERIFICACIÓN GENERAL DEL PROYECTO (resumen final)
-- Ejecutar como acme_school en el primario
-- ============================================================

-- Objetos del schema
SELECT object_type, COUNT(*) AS cantidad, 
       SUM(CASE WHEN status = 'VALID' THEN 1 ELSE 0 END) AS validos,
       SUM(CASE WHEN status != 'VALID' THEN 1 ELSE 0 END) AS invalidos
FROM user_objects
GROUP BY object_type
ORDER BY object_type;

-- Resumen de datos
SELECT 'estudiantes' AS tabla, COUNT(*) AS total FROM estudiante UNION ALL
SELECT 'docentes',    COUNT(*) FROM docente    UNION ALL
SELECT 'cursos',      COUNT(*) FROM curso      UNION ALL
SELECT 'periodos',    COUNT(*) FROM periodo    UNION ALL
SELECT 'secciones',   COUNT(*) FROM seccion    UNION ALL
SELECT 'inscripciones', COUNT(*) FROM inscripcion UNION ALL
SELECT 'notas',       COUNT(*) FROM nota       UNION ALL
SELECT 'auditoria',   COUNT(*) FROM auditoria_academica
ORDER BY tabla;

-- Packages y funciones
SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE','PACKAGE BODY','FUNCTION','TRIGGER','PROCEDURE')
ORDER BY object_type, object_name;

-- Roles del proyecto
SELECT role FROM dba_roles WHERE role LIKE 'ROL_%' ORDER BY role;

-- Índices creados
SELECT index_name, table_name
FROM user_indexes
WHERE index_name LIKE 'IDX_%'
ORDER BY table_name;

-- Tablas DW
SELECT table_name, num_rows
FROM user_tables
WHERE table_name LIKE 'DW_%'
ORDER BY table_name;
