-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 06_deadlock_solucion.sql
-- Descripción: Resolución del deadlock
-- Responsable: Wuili
-- Tarea: T-017
-- ============================================================

-- Soluciones posibles:
--   1. Orden fijo de locks (siempre bloquear en el mismo orden)
--   2. SELECT ... FOR UPDATE con NOWAIT o WAIT n
--   3. Reducción del alcance transaccional
--
-- Implementar solución y explicar causa raíz:
--   - Causa: acceso a recursos en orden inverso
--   - Solución elegida: [documentar]
--   - Evidencia: script corregido que no produce deadlock

-- TODO: Implementar después de T-016
