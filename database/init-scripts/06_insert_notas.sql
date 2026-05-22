-- ============================================================
-- ACME SCHOOL - Notas de períodos cerrados
-- Ejecutar como: acme_school
-- Tarea: T-009 (Julian)
-- Descripción: Notas variadas para análisis DW y rendimiento
-- ============================================================

ALTER SESSION SET CURRENT_SCHEMA = acme_school;

-- ==================== NOTAS PERIODO 2024-1 ====================
-- Inscripción 1: EST-001 en Cálculo I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (1, 'Parcial 1', 78.50, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (1, 'Parcial 2', 82.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (1, 'Final', 85.00, 'Buen desempeño');

-- Inscripción 2: EST-002 en Cálculo I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (2, 'Parcial 1', 65.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (2, 'Parcial 2', 70.50, 'Mejoró');
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (2, 'Final', 72.00, NULL);

-- Inscripción 3: EST-003 en Cálculo I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (3, 'Parcial 1', 45.00, 'Necesita refuerzo');
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (3, 'Parcial 2', 52.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (3, 'Final', 55.00, 'Reprobado');

-- Inscripción 4: EST-004 en Cálculo I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (4, 'Parcial 1', 91.00, 'Excelente');
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (4, 'Parcial 2', 88.50, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (4, 'Final', 93.00, 'Mejor nota del curso');

-- Inscripción 6: EST-006 en Cálculo I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (6, 'Parcial 1', 73.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (6, 'Parcial 2', 68.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (6, 'Final', 71.50, NULL);

-- Inscripción 7: EST-007 en Cálculo I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (7, 'Parcial 1', 60.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (7, 'Parcial 2', 58.00, 'Bajo rendimiento');
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (7, 'Final', 62.00, 'Aprobó por poco');

-- Inscripción 8: EST-008 en Cálculo I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (8, 'Parcial 1', 87.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (8, 'Parcial 2', 90.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (8, 'Final', 88.50, NULL);

-- Inscripción 9: EST-001 en Programación I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (9, 'Parcial 1', 92.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (9, 'Parcial 2', 95.00, 'Excelente programador');
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (9, 'Final', 94.00, NULL);

-- Inscripción 10: EST-002 en Programación I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (10, 'Parcial 1', 55.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (10, 'Parcial 2', 60.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (10, 'Final', 58.00, 'Reprobado');

-- Inscripción 11: EST-003 en Programación I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (11, 'Parcial 1', 75.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (11, 'Parcial 2', 80.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (11, 'Final', 77.50, NULL);

-- Inscripción 12: EST-009 en Programación I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (12, 'Parcial 1', 83.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (12, 'Parcial 2', 79.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (12, 'Final', 81.00, NULL);

-- Inscripción 13: EST-010 en Programación I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (13, 'Parcial 1', 68.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (13, 'Parcial 2', 72.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (13, 'Final', 70.00, NULL);

-- Inscripción 14: EST-011 en Programación I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (14, 'Parcial 1', 48.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (14, 'Parcial 2', 50.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (14, 'Final', 45.00, 'Reprobado');

-- Inscripción 16: EST-013 en Programación I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (16, 'Parcial 1', 88.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (16, 'Parcial 2', 85.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (16, 'Final', 90.00, NULL);

-- Inscripción 17: EST-001 en BD I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (17, 'Parcial 1', 88.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (17, 'Parcial 2', 91.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (17, 'Final', 89.50, NULL);

-- Inscripción 18: EST-004 en BD I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (18, 'Parcial 1', 95.00, 'Excelente');
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (18, 'Parcial 2', 92.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (18, 'Final', 96.00, 'Mejor del curso');

-- Inscripción 19: EST-005 en BD I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (19, 'Parcial 1', 62.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (19, 'Parcial 2', 65.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (19, 'Final', 63.50, NULL);

-- Inscripción 20: EST-014 en BD I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (20, 'Parcial 1', 77.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (20, 'Parcial 2', 80.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (20, 'Final', 78.50, NULL);

-- Inscripción 21: EST-015 en BD I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (21, 'Parcial 1', 42.00, 'Muy bajo');
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (21, 'Parcial 2', 50.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (21, 'Final', 48.00, 'Reprobado');

-- Inscripción 22: EST-016 en BD I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (22, 'Parcial 1', 85.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (22, 'Parcial 2', 82.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (22, 'Final', 87.00, NULL);

-- Inscripción 23: EST-017 en BD I
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (23, 'Parcial 1', 70.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (23, 'Parcial 2', 73.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (23, 'Final', 71.00, NULL);

-- ==================== NOTAS PERIODO 2024-2 ====================
-- Inscripción 35: EST-001 en Álgebra Lineal
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (35, 'Parcial 1', 80.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (35, 'Parcial 2', 83.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (35, 'Final', 82.00, NULL);

-- Inscripción 36: EST-002 en Álgebra Lineal
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (36, 'Parcial 1', 58.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (36, 'Parcial 2', 55.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (36, 'Final', 60.00, 'Reprobado');

-- Inscripción 37: EST-003 en Álgebra Lineal
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (37, 'Parcial 1', 72.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (37, 'Parcial 2', 75.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (37, 'Final', 74.00, NULL);

-- Inscripción 44: EST-001 en Estructuras de Datos
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (44, 'Parcial 1', 90.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (44, 'Parcial 2', 93.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (44, 'Final', 91.50, NULL);

-- Inscripción 45: EST-002 en Estructuras de Datos
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (45, 'Parcial 1', 63.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (45, 'Parcial 2', 67.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (45, 'Final', 65.00, NULL);

-- Inscripción 53: EST-001 en BD II
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (53, 'Parcial 1', 86.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (53, 'Parcial 2', 89.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (53, 'Final', 88.00, NULL);

-- Inscripción 54: EST-004 en BD II
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (54, 'Parcial 1', 94.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (54, 'Parcial 2', 91.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (54, 'Final', 95.00, NULL);

-- Inscripción 55: EST-005 en BD II
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (55, 'Parcial 1', 58.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (55, 'Parcial 2', 55.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (55, 'Final', 52.00, 'Reprobado');

-- Inscripción 60: EST-006 en SO
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (60, 'Parcial 1', 76.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (60, 'Parcial 2', 79.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (60, 'Final', 77.50, NULL);

-- Inscripción 61: EST-007 en SO
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (61, 'Parcial 1', 82.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (61, 'Parcial 2', 85.00, NULL);
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor, observacion) VALUES (61, 'Final', 83.50, NULL);

COMMIT;
