-- Intentos de acceso no autorizado. Cada bloque se ejecuta conectado
-- como el usuario indicado; capturar SHOW USER y el error ORA.

-- ============================================================
-- DEMO 1: Analista BI intenta INSERT (solo tiene SELECT)
-- Conectar como: analista_bi / Analista2025@FREEPDB1
-- ============================================================

-- > sqlplus analista_bi/Analista2025@FREEPDB1
-- SQL> SHOW USER
-- USER is "ANALISTA_BI"

-- Caso permitido (SELECT vía rol_reportes):
SELECT COUNT(*) AS total_estudiantes FROM acme_school.estudiante;

-- Caso DENEGADO:
INSERT INTO acme_school.estudiante (codigo, nombre, apellido, email)
VALUES ('EST-HACK', 'Intruso', 'NoAutorizado', 'hack@test.com');
-- ERROR esperado:
--   ORA-01031: insufficient privileges

-- ============================================================
-- DEMO 2: Docente intenta DROP TABLE
-- Conectar como: docente_mendoza / Docente2025@FREEPDB1
-- ============================================================

-- > sqlplus docente_mendoza/Docente2025@FREEPDB1
-- SQL> SHOW USER
-- USER is "DOCENTE_MENDOZA"

-- Caso permitido (SELECT en nota):
SELECT COUNT(*) AS total_notas FROM acme_school.nota;

-- Caso DENEGADO:
DROP TABLE acme_school.estudiante;
-- ERROR esperado:
--   ORA-01031: insufficient privileges

-- ============================================================
-- DEMO 3: Docente intenta DELETE en inscripción
-- Conectar como: docente_mendoza / Docente2025@FREEPDB1
-- ============================================================

-- Caso permitido (SELECT en inscripcion):
SELECT COUNT(*) AS total_inscripciones FROM acme_school.inscripcion;

-- Caso DENEGADO (rol_docente NO tiene DELETE):
DELETE FROM acme_school.inscripcion WHERE inscripcion_id = 1;
-- ERROR esperado:
--   ORA-01031: insufficient privileges

-- ============================================================
-- DEMO 4: Auditor intenta UPDATE de notas
-- Conectar como: auditor_sistema / Auditor2025@FREEPDB1
-- ============================================================

-- > sqlplus auditor_sistema/Auditor2025@FREEPDB1
-- SQL> SHOW USER
-- USER is "AUDITOR_SISTEMA"

-- Caso permitido (SELECT en auditoria):
SELECT COUNT(*) AS registros_auditoria
FROM acme_school.auditoria_academica;

-- Caso DENEGADO:
UPDATE acme_school.nota SET valor = 100 WHERE nota_id = 1;
-- ERROR esperado:
--   ORA-01031: insufficient privileges

-- ============================================================
-- DEMO 5: App intenta acceder a tabla de auditoría
-- Conectar como: app_academica / AppAcad2025@FREEPDB1
-- ============================================================

-- > sqlplus app_academica/AppAcad2025@FREEPDB1
-- SQL> SHOW USER
-- USER is "APP_ACADEMICA"

-- Caso permitido (SELECT en inscripcion):
SELECT COUNT(*) AS inscripciones FROM acme_school.inscripcion;

-- Caso DENEGADO (app NO tiene acceso a auditoría):
SELECT * FROM acme_school.auditoria_academica;
-- ERROR esperado:
--   ORA-00942: table or view does not exist
--   (El objeto existe pero el usuario no tiene privilegios para verlo)

-- ============================================================
-- DEMO 6: Docente intenta modificar datos fuera de su alcance
-- Conectar como: docente_mendoza / Docente2025@FREEPDB1
-- ============================================================

-- Caso DENEGADO (rol_docente no tiene UPDATE en seccion):
UPDATE acme_school.seccion SET cupo_maximo = 999 WHERE seccion_id = 1;
-- ERROR esperado:
--   ORA-01031: insufficient privileges

-- Caso DENEGADO (rol_docente no tiene INSERT en estudiante):
INSERT INTO acme_school.estudiante (codigo, nombre, apellido, email)
VALUES ('EST-DOC', 'Creado', 'PorDocente', 'doc@test.com');
-- ERROR esperado:
--   ORA-01031: insufficient privileges

-- ============================================================
-- RESUMEN DE INTENTOS Y RESULTADOS
-- ============================================================
--
-- | # | Usuario         | Acción intentada              | Resultado          |
-- |---|-----------------|-------------------------------|--------------------|
-- | 1 | analista_bi     | INSERT en estudiante          | ORA-01031          |
-- | 2 | docente_mendoza | DROP TABLE estudiante         | ORA-01031          |
-- | 3 | docente_mendoza | DELETE en inscripcion         | ORA-01031          |
-- | 4 | auditor_sistema | UPDATE en nota                | ORA-01031          |
-- | 5 | app_academica   | SELECT en auditoria_academica | ORA-00942          |
-- | 6 | docente_mendoza | UPDATE en seccion             | ORA-01031          |
--
-- Conclusion: el modelo de seguridad funciona conforme al
-- principio de minimo privilegio. Cada usuario solo puede
-- realizar las operaciones estrictamente necesarias para su rol.
