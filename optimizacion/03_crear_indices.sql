-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 03_crear_indices.sql
-- Descripción: Índices estratégicos sobre tablas críticas
-- Responsable: Julian
-- Tarea: T-036
-- ============================================================

-- Índices justificados:
--   - inscripcion(estudiante_id) → búsquedas por estudiante
--   - inscripcion(seccion_id) → búsquedas por sección
--   - nota(inscripcion_id) → JOIN con inscripciones
--   - seccion(curso_id, periodo_id) → filtros por curso/período
--   - seccion(docente_id) → búsquedas por docente
--
-- NO indexar todo indiscriminadamente; justificar cada índice

-- Ejemplo:
-- CREATE INDEX idx_inscripcion_estudiante ON inscripcion(estudiante_id);
-- CREATE INDEX idx_inscripcion_seccion ON inscripcion(seccion_id);
-- CREATE INDEX idx_nota_inscripcion ON nota(inscripcion_id);
-- CREATE INDEX idx_seccion_curso_periodo ON seccion(curso_id, periodo_id);
-- CREATE INDEX idx_seccion_docente ON seccion(docente_id);

-- TODO: Implementar después de T-034
