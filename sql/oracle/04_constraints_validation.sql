-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 04_constraints_validation.sql
-- Descripción: Pruebas de integridad referencial y constraints
-- Responsable: Emmanuel
-- Tarea: T-010
-- ============================================================

-- Probar casos negativos que deben fallar:
--   1. INSERT con FK inválida
--   2. INSERT con valor UNIQUE duplicado
--   3. INSERT con CHECK constraint violado (nota > 100, cupo < 0, etc.)
--   4. DELETE de registro referenciado por FK
--
-- Capturar errores ORA esperados:
--   ORA-02291: integrity constraint violated - parent key not found
--   ORA-00001: unique constraint violated
--   ORA-02290: check constraint violated

-- TODO: Implementar después de T-008 y T-009
