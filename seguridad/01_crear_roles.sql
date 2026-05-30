-- Roles y usuarios diferenciados bajo el principio de mínimo privilegio.
-- Ejecutar como acme_school. Requiere las tablas ya creadas.

-- ==================== ROLES ACADÉMICOS ====================

-- ROL 1: Administrador Académico
-- Acceso CRUD completo sobre todas las tablas operacionales
-- Puede ejecutar todos los packages del sistema
CREATE ROLE rol_admin_academico;
GRANT SELECT, INSERT, UPDATE, DELETE ON acme_school.estudiante TO rol_admin_academico;
GRANT SELECT, INSERT, UPDATE, DELETE ON acme_school.docente TO rol_admin_academico;
GRANT SELECT, INSERT, UPDATE, DELETE ON acme_school.curso TO rol_admin_academico;
GRANT SELECT, INSERT, UPDATE, DELETE ON acme_school.periodo TO rol_admin_academico;
GRANT SELECT, INSERT, UPDATE, DELETE ON acme_school.seccion TO rol_admin_academico;
GRANT SELECT, INSERT, UPDATE, DELETE ON acme_school.inscripcion TO rol_admin_academico;
GRANT SELECT, INSERT, UPDATE, DELETE ON acme_school.nota TO rol_admin_academico;
GRANT SELECT ON acme_school.auditoria_academica TO rol_admin_academico;

-- ROL 2: Aplicación (backend/API)
-- Lectura general + escritura controlada en inscripción y nota
CREATE ROLE rol_app;
GRANT SELECT ON acme_school.estudiante TO rol_app;
GRANT SELECT ON acme_school.docente TO rol_app;
GRANT SELECT ON acme_school.curso TO rol_app;
GRANT SELECT ON acme_school.periodo TO rol_app;
GRANT SELECT ON acme_school.seccion TO rol_app;
GRANT SELECT, INSERT, UPDATE ON acme_school.inscripcion TO rol_app;
GRANT SELECT, INSERT, UPDATE ON acme_school.nota TO rol_app;
GRANT UPDATE (cupo_disponible) ON acme_school.seccion TO rol_app;
-- NOTA: la app actualiza solo el cupo de seccion, no otros campos

-- ROL 3: Docente
-- Consulta de estudiantes/cursos + registro y actualización de notas
-- NO puede eliminar registros ni modificar inscripciones
CREATE ROLE rol_docente;
GRANT SELECT ON acme_school.estudiante TO rol_docente;
GRANT SELECT ON acme_school.curso TO rol_docente;
GRANT SELECT ON acme_school.periodo TO rol_docente;
GRANT SELECT ON acme_school.seccion TO rol_docente;
GRANT SELECT ON acme_school.inscripcion TO rol_docente;
GRANT SELECT, INSERT, UPDATE ON acme_school.nota TO rol_docente;
-- Sin acceso a tabla docente (no ve datos de otros docentes)
-- Sin DELETE en ninguna tabla

-- ROL 4: Auditor
-- Solo lectura de auditoría y datos relacionados
CREATE ROLE rol_auditor;
GRANT SELECT ON acme_school.auditoria_academica TO rol_auditor;
GRANT SELECT ON acme_school.estudiante TO rol_auditor;
GRANT SELECT ON acme_school.inscripcion TO rol_auditor;
GRANT SELECT ON acme_school.nota TO rol_auditor;
-- Sin INSERT, UPDATE ni DELETE en ninguna tabla

-- ROL 5: Reportes / BI
-- Solo SELECT en tablas operacionales (sin auditoría)
CREATE ROLE rol_reportes;
GRANT SELECT ON acme_school.estudiante TO rol_reportes;
GRANT SELECT ON acme_school.docente TO rol_reportes;
GRANT SELECT ON acme_school.curso TO rol_reportes;
GRANT SELECT ON acme_school.periodo TO rol_reportes;
GRANT SELECT ON acme_school.seccion TO rol_reportes;
GRANT SELECT ON acme_school.inscripcion TO rol_reportes;
GRANT SELECT ON acme_school.nota TO rol_reportes;
-- Sin acceso a auditoría (datos sensibles de cambios)

-- ==================== USUARIOS DE DEMOSTRACIÓN ====================

-- Administrador del sistema académico
CREATE USER admin_academico IDENTIFIED BY AdminAcad2025
  DEFAULT TABLESPACE acme_data TEMPORARY TABLESPACE temp;
GRANT CREATE SESSION TO admin_academico;
GRANT rol_admin_academico TO admin_academico;

-- Usuario de la aplicación backend
CREATE USER app_academica IDENTIFIED BY AppAcad2025
  DEFAULT TABLESPACE acme_data TEMPORARY TABLESPACE temp;
GRANT CREATE SESSION TO app_academica;
GRANT rol_app TO app_academica;

-- Docente (ejemplo: Carlos Mendoza)
CREATE USER docente_mendoza IDENTIFIED BY Docente2025
  DEFAULT TABLESPACE acme_data TEMPORARY TABLESPACE temp;
GRANT CREATE SESSION TO docente_mendoza;
GRANT rol_docente TO docente_mendoza;

-- Auditor del sistema
CREATE USER auditor_sistema IDENTIFIED BY Auditor2025
  DEFAULT TABLESPACE acme_data TEMPORARY TABLESPACE temp;
GRANT CREATE SESSION TO auditor_sistema;
GRANT rol_auditor TO auditor_sistema;

-- Analista de BI / Reportes
CREATE USER analista_bi IDENTIFIED BY Analista2025
  DEFAULT TABLESPACE acme_data TEMPORARY TABLESPACE temp;
GRANT CREATE SESSION TO analista_bi;
GRANT rol_reportes TO analista_bi;

COMMIT;

-- ==================== VERIFICACIÓN ====================

-- 1. Roles creados
PROMPT === ROLES CREADOS ===
SELECT role FROM dba_roles WHERE role LIKE 'ROL_%' ORDER BY role;

-- 2. Privilegios por rol
PROMPT === PRIVILEGIOS POR ROL ===
SELECT role, privilege, owner || '.' || table_name AS objeto
FROM role_tab_privs
WHERE role LIKE 'ROL_%'
ORDER BY role, table_name, privilege;

-- 3. Usuarios y sus roles
PROMPT === USUARIOS Y ROLES ASIGNADOS ===
SELECT grantee, granted_role
FROM dba_role_privs
WHERE granted_role LIKE 'ROL_%'
ORDER BY grantee;
