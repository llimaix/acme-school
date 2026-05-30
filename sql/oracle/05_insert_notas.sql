-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 05_insert_notas.sql
-- Descripción: Notas de evaluaciones para períodos cerrados
-- Responsable: Luis (completado por Luis ante ausencia de Julian)
-- Tarea: T-009
-- Ejecutar como: acme_school
-- ============================================================
-- Notas variadas: aprobados (>=61) y reprobados (<61)
-- Tipos: Parcial 1, Parcial 2, Final
-- ============================================================

-- ==================== NOTAS PERIODO 2024-1 ====================

-- Inscripción 1: EST-001 en Cálculo I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (1, 'Parcial 1', 78.50);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (1, 'Parcial 2', 82.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (1, 'Final', 85.00);

-- Inscripción 2: EST-002 en Cálculo I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (2, 'Parcial 1', 65.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (2, 'Parcial 2', 70.50);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (2, 'Final', 72.00);

-- Inscripción 3: EST-003 en Cálculo I (REPROBADO)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (3, 'Parcial 1', 45.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (3, 'Parcial 2', 52.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (3, 'Final', 55.00);

-- Inscripción 4: EST-004 en Cálculo I (aprobado alto)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (4, 'Parcial 1', 91.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (4, 'Parcial 2', 88.50);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (4, 'Final', 93.00);

-- Inscripción 6: EST-006 en Cálculo I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (6, 'Parcial 1', 73.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (6, 'Parcial 2', 68.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (6, 'Final', 71.50);

-- Inscripción 7: EST-007 en Cálculo I (aprobado justo)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (7, 'Parcial 1', 60.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (7, 'Parcial 2', 58.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (7, 'Final', 62.00);

-- Inscripción 8: EST-008 en Cálculo I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (8, 'Parcial 1', 87.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (8, 'Parcial 2', 90.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (8, 'Final', 88.50);

-- Inscripción 9: EST-001 en Programación I (aprobado alto)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (9, 'Parcial 1', 92.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (9, 'Parcial 2', 95.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (9, 'Final', 94.00);

-- Inscripción 10: EST-002 en Programación I (REPROBADO)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (10, 'Parcial 1', 55.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (10, 'Parcial 2', 60.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (10, 'Final', 58.00);

-- Inscripción 11: EST-003 en Programación I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (11, 'Parcial 1', 75.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (11, 'Parcial 2', 80.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (11, 'Final', 77.50);

-- Inscripción 12: EST-009 en Programación I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (12, 'Parcial 1', 83.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (12, 'Parcial 2', 79.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (12, 'Final', 81.00);

-- Inscripción 13: EST-010 en Programación I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (13, 'Parcial 1', 68.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (13, 'Parcial 2', 72.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (13, 'Final', 70.00);

-- Inscripción 14: EST-011 en Programación I (REPROBADO)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (14, 'Parcial 1', 48.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (14, 'Parcial 2', 50.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (14, 'Final', 45.00);

-- Inscripción 15: EST-013 en Programación I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (15, 'Parcial 1', 88.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (15, 'Parcial 2', 85.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (15, 'Final', 90.00);

-- Inscripción 16: EST-001 en BD I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (16, 'Parcial 1', 88.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (16, 'Parcial 2', 91.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (16, 'Final', 89.50);

-- Inscripción 17: EST-004 en BD I (aprobado alto)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (17, 'Parcial 1', 95.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (17, 'Parcial 2', 92.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (17, 'Final', 96.00);

-- Inscripción 18: EST-005 en BD I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (18, 'Parcial 1', 62.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (18, 'Parcial 2', 65.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (18, 'Final', 63.50);

-- Inscripción 19: EST-014 en BD I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (19, 'Parcial 1', 77.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (19, 'Parcial 2', 80.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (19, 'Final', 78.50);

-- Inscripción 20: EST-015 en BD I (REPROBADO)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (20, 'Parcial 1', 42.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (20, 'Parcial 2', 50.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (20, 'Final', 48.00);

-- Inscripción 21: EST-016 en BD I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (21, 'Parcial 1', 85.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (21, 'Parcial 2', 82.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (21, 'Final', 87.00);

-- Inscripción 22: EST-017 en BD I (aprobado)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (22, 'Parcial 1', 70.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (22, 'Parcial 2', 73.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (22, 'Final', 71.00);

-- ==================== NOTAS PERIODO 2024-2 ====================

-- Inscripción 36 (EST-001 en Álgebra Lineal)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (36, 'Parcial 1', 80.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (36, 'Parcial 2', 83.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (36, 'Final', 82.00);

-- Inscripción 37 (EST-002 en Álgebra Lineal - REPROBADO)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (37, 'Parcial 1', 58.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (37, 'Parcial 2', 55.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (37, 'Final', 60.00);

-- Inscripción 38 (EST-003 en Álgebra Lineal)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (38, 'Parcial 1', 72.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (38, 'Parcial 2', 75.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (38, 'Final', 74.00);

-- Inscripción 45 (EST-001 en Estructuras de Datos)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (45, 'Parcial 1', 90.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (45, 'Parcial 2', 93.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (45, 'Final', 91.50);

-- Inscripción 46 (EST-002 en Estructuras de Datos)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (46, 'Parcial 1', 63.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (46, 'Parcial 2', 67.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (46, 'Final', 65.00);

-- Inscripción 51 (EST-001 en BD II)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (51, 'Parcial 1', 86.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (51, 'Parcial 2', 89.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (51, 'Final', 88.00);

-- Inscripción 52 (EST-004 en BD II)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (52, 'Parcial 1', 94.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (52, 'Parcial 2', 91.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (52, 'Final', 95.00);

-- Inscripción 53 (EST-005 en BD II - REPROBADO)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (53, 'Parcial 1', 58.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (53, 'Parcial 2', 55.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (53, 'Final', 52.00);

-- Inscripción 57 (EST-006 en SO)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (57, 'Parcial 1', 76.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (57, 'Parcial 2', 79.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (57, 'Final', 77.50);

-- Inscripción 58 (EST-007 en SO)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (58, 'Parcial 1', 82.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (58, 'Parcial 2', 85.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (58, 'Final', 83.50);

-- Inscripción 62 (EST-008 en IA)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (62, 'Parcial 1', 70.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (62, 'Parcial 2', 74.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (62, 'Final', 72.00);

-- Inscripción 63 (EST-009 en IA)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (63, 'Parcial 1', 88.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (63, 'Parcial 2', 91.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (63, 'Final', 90.00);

-- Inscripción 64 (EST-010 en IA - REPROBADO)
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (64, 'Parcial 1', 50.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (64, 'Parcial 2', 48.00);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (64, 'Final', 53.00);

COMMIT;

-- ==================== VERIFICACIÓN ====================
SELECT 'estudiantes' AS tabla, COUNT(*) AS total FROM estudiante UNION ALL
SELECT 'docentes',    COUNT(*) FROM docente    UNION ALL
SELECT 'cursos',      COUNT(*) FROM curso      UNION ALL
SELECT 'periodos',    COUNT(*) FROM periodo    UNION ALL
SELECT 'secciones',   COUNT(*) FROM seccion    UNION ALL
SELECT 'inscripciones', COUNT(*) FROM inscripcion UNION ALL
SELECT 'notas',       COUNT(*) FROM nota
ORDER BY tabla;
