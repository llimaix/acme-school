-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 01_create_sequences.sql
-- Descripción: Secuencias para generación de PKs
-- Responsable: Wuili
-- Tarea: T-008
-- Ejecutar como: acme_school (o usuario con CREATE SEQUENCE)
-- ============================================================

-- Asegurar que estamos trabajando sobre el schema correcto
ALTER SESSION SET CURRENT_SCHEMA = acme_school;

-- ==================== SECUENCIAS ====================
-- START WITH 1, INCREMENT BY 1, NOCACHE
-- NOCACHE evita huecos en los IDs ante crashes
-- (importante para auditoría y trazabilidad)

CREATE SEQUENCE seq_estudiante
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE seq_docente
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE seq_curso
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE seq_periodo
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE seq_seccion
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE seq_inscripcion
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE seq_nota
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE seq_auditoria
    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- ==================== VERIFICACIÓN ====================
SELECT sequence_name, last_number, increment_by, cache_size
FROM user_sequences
ORDER BY sequence_name;
