-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Trigger: trg_auditoria
-- Descripción: Auditoría de cambios en notas e inscripciones
-- Responsable: Emmanuel
-- Tareas: T-020, T-021
-- ============================================================

-- Tabla de auditoría:
--   auditoria_academica (
--     auditoria_id, usuario, fecha_hora, operacion,
--     tabla_afectada, pk_registro, valor_anterior, valor_nuevo
--   )
--
-- Usar: USER, SYSTIMESTAMP, :OLD, :NEW

-- DDL tabla auditoría
/*
CREATE TABLE auditoria_academica (
    auditoria_id    NUMBER PRIMARY KEY,
    usuario         VARCHAR2(50) DEFAULT USER,
    fecha_hora      TIMESTAMP DEFAULT SYSTIMESTAMP,
    operacion       VARCHAR2(10) NOT NULL, -- INSERT/UPDATE/DELETE
    tabla_afectada  VARCHAR2(50) NOT NULL,
    pk_registro     NUMBER,
    valor_anterior  VARCHAR2(4000),
    valor_nuevo     VARCHAR2(4000)
);

CREATE SEQUENCE seq_auditoria START WITH 1 INCREMENT BY 1 NOCACHE;
*/

-- Trigger
-- TODO: Implementar después de T-020
