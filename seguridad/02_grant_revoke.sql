-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: seguridad/02_grant_revoke.sql
-- Responsable: Luis
-- Tarea: T-030
-- Descripción: Demostración explícita de GRANT y REVOKE
--   sobre roles ya existentes
-- Ejecutar como: acme_school
-- Prerrequisito: 01_crear_roles.sql ejecutado
-- ============================================================

ALTER SESSION SET CURRENT_SCHEMA = acme_school;
SET SERVEROUTPUT ON;

-- ============================================================
-- ESCENARIO 1: GRANT temporal a docente
-- Inicialmente rol_docente NO tiene acceso a tabla docente
-- ============================================================

PROMPT === Escenario 1: GRANT temporal a docente ===

-- Verificar que no tiene acceso (debe estar vacío)
PROMPT Privilegios actuales de rol_docente sobre tabla docente:
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';

-- Otorgar privilegio
GRANT SELECT ON acme_school.docente TO rol_docente;

-- Verificar que ahora sí tiene
PROMPT Despues de GRANT:
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';

-- Revocar
REVOKE SELECT ON acme_school.docente FROM rol_docente;

-- Verificar que ya no tiene
PROMPT Despues de REVOKE:
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';

-- ============================================================
-- ESCENARIO 2: GRANT/REVOKE de INSERT a analista_bi
-- analista_bi solo debe tener SELECT, demostrar control
-- ============================================================

PROMPT === Escenario 2: GRANT INSERT temporal a rol_reportes ===

-- Privilegios actuales del rol_reportes sobre estudiante
PROMPT Antes:
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_REPORTES' AND table_name = 'ESTUDIANTE';

-- Dar INSERT temporal
GRANT INSERT ON acme_school.estudiante TO rol_reportes;

PROMPT Despues de GRANT INSERT:
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_REPORTES' AND table_name = 'ESTUDIANTE';

-- Revocar inmediatamente
REVOKE INSERT ON acme_school.estudiante FROM rol_reportes;

PROMPT Despues de REVOKE INSERT:
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_REPORTES' AND table_name = 'ESTUDIANTE';

-- ============================================================
-- ESCENARIO 3: GRANT/REVOKE de rol completo a usuario
-- ============================================================

PROMPT === Escenario 3: GRANT/REVOKE de rol a usuario ===

-- Otorgar rol_auditor a docente_mendoza temporalmente
GRANT rol_auditor TO docente_mendoza;

PROMPT Roles de docente_mendoza despues de GRANT:
SELECT granted_role FROM dba_role_privs
WHERE grantee = 'DOCENTE_MENDOZA'
ORDER BY granted_role;

-- Revocar
REVOKE rol_auditor FROM docente_mendoza;

PROMPT Roles de docente_mendoza despues de REVOKE:
SELECT granted_role FROM dba_role_privs
WHERE grantee = 'DOCENTE_MENDOZA'
ORDER BY granted_role;

-- ============================================================
-- MATRIZ FINAL DE PRIVILEGIOS
-- ============================================================

PROMPT === MATRIZ DE PRIVILEGIOS POR ROL Y TABLA ===

SELECT
    table_name AS tabla,
    LISTAGG(CASE WHEN role = 'ROL_ADMIN_ACADEMICO' THEN privilege END, ',') WITHIN GROUP (ORDER BY privilege) AS admin,
    LISTAGG(CASE WHEN role = 'ROL_APP'             THEN privilege END, ',') WITHIN GROUP (ORDER BY privilege) AS app,
    LISTAGG(CASE WHEN role = 'ROL_DOCENTE'         THEN privilege END, ',') WITHIN GROUP (ORDER BY privilege) AS docente,
    LISTAGG(CASE WHEN role = 'ROL_AUDITOR'         THEN privilege END, ',') WITHIN GROUP (ORDER BY privilege) AS auditor,
    LISTAGG(CASE WHEN role = 'ROL_REPORTES'        THEN privilege END, ',') WITHIN GROUP (ORDER BY privilege) AS reportes
FROM role_tab_privs
WHERE role LIKE 'ROL_%'
  AND owner = 'ACME_SCHOOL'
GROUP BY table_name
ORDER BY table_name;

-- ============================================================
-- LIMPIEZA: Garantizar estado consistente al final
-- ============================================================

-- Asegurar que el estado final sea el mismo que después de 01_crear_roles.sql
-- (no quedan grants temporales activos)

PROMPT === Estado final: roles tal como los definio T-029 ===
