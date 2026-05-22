-- ============================================================
-- ACME SCHOOL - Inscripciones y Notas
-- Ejecutar como: acme_school
-- Tarea: T-009 (Julian)
-- Descripción: Inscripciones y notas para períodos cerrados
--   + inscripciones activas en período 2025-1
-- ============================================================

ALTER SESSION SET CURRENT_SCHEMA = acme_school;

-- ==================== INSCRIPCIONES PERIODO 2024-1 ====================
-- Sección 1: Cálculo I - A (seccion_id=1)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 1, TIMESTAMP '2024-01-16 08:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (2, 1, TIMESTAMP '2024-01-16 09:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 1, TIMESTAMP '2024-01-16 10:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (4, 1, TIMESTAMP '2024-01-16 10:45:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (5, 1, TIMESTAMP '2024-01-16 11:30:00', 'RETIRADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (6, 1, TIMESTAMP '2024-01-17 08:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (7, 1, TIMESTAMP '2024-01-17 09:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (8, 1, TIMESTAMP '2024-01-17 10:00:00', 'COMPLETADO');

-- Sección 2: Programación I - A (seccion_id=2)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 2, TIMESTAMP '2024-01-16 08:35:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (2, 2, TIMESTAMP '2024-01-16 09:20:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 2, TIMESTAMP '2024-01-16 10:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (9, 2, TIMESTAMP '2024-01-17 08:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (10, 2, TIMESTAMP '2024-01-17 09:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (11, 2, TIMESTAMP '2024-01-17 10:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (12, 2, TIMESTAMP '2024-01-18 08:00:00', 'RETIRADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (13, 2, TIMESTAMP '2024-01-18 09:00:00', 'COMPLETADO');

-- Sección 3: BD I - A (seccion_id=3)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 3, TIMESTAMP '2024-01-16 08:40:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (4, 3, TIMESTAMP '2024-01-16 10:50:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (5, 3, TIMESTAMP '2024-01-16 11:35:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (14, 3, TIMESTAMP '2024-01-17 08:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (15, 3, TIMESTAMP '2024-01-17 09:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (16, 3, TIMESTAMP '2024-01-17 10:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (17, 3, TIMESTAMP '2024-01-18 08:00:00', 'COMPLETADO');

-- Sección 4: Redes - A (seccion_id=4)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (6, 4, TIMESTAMP '2024-01-17 08:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (7, 4, TIMESTAMP '2024-01-17 09:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (18, 4, TIMESTAMP '2024-01-17 10:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (19, 4, TIMESTAMP '2024-01-18 08:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (20, 4, TIMESTAMP '2024-01-18 09:05:00', 'COMPLETADO');

-- Sección 5: Estadística - A (seccion_id=5)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (8, 5, TIMESTAMP '2024-01-17 10:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (9, 5, TIMESTAMP '2024-01-17 11:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (10, 5, TIMESTAMP '2024-01-18 08:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (21, 5, TIMESTAMP '2024-01-18 09:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (22, 5, TIMESTAMP '2024-01-18 10:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (23, 5, TIMESTAMP '2024-01-19 08:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (24, 5, TIMESTAMP '2024-01-19 09:00:00', 'RETIRADO');

-- ==================== INSCRIPCIONES PERIODO 2024-2 ====================
-- Sección 6: Álgebra Lineal (seccion_id=6)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 6, TIMESTAMP '2024-07-16 08:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (2, 6, TIMESTAMP '2024-07-16 08:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 6, TIMESTAMP '2024-07-16 09:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (6, 6, TIMESTAMP '2024-07-16 09:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (7, 6, TIMESTAMP '2024-07-16 10:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (11, 6, TIMESTAMP '2024-07-16 10:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (13, 6, TIMESTAMP '2024-07-16 11:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (14, 6, TIMESTAMP '2024-07-17 08:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (25, 6, TIMESTAMP '2024-07-17 08:30:00', 'RETIRADO');

-- Sección 7: Estructuras de Datos (seccion_id=7)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 7, TIMESTAMP '2024-07-16 08:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (2, 7, TIMESTAMP '2024-07-16 08:35:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 7, TIMESTAMP '2024-07-16 09:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (9, 7, TIMESTAMP '2024-07-16 09:35:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (10, 7, TIMESTAMP '2024-07-16 10:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (11, 7, TIMESTAMP '2024-07-16 10:35:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (13, 7, TIMESTAMP '2024-07-16 11:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (15, 7, TIMESTAMP '2024-07-17 08:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (16, 7, TIMESTAMP '2024-07-17 08:35:00', 'COMPLETADO');

-- Sección 8: BD II (seccion_id=8)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 8, TIMESTAMP '2024-07-16 08:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (4, 8, TIMESTAMP '2024-07-16 10:55:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (5, 8, TIMESTAMP '2024-07-16 11:40:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (14, 8, TIMESTAMP '2024-07-17 08:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (16, 8, TIMESTAMP '2024-07-17 08:40:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (17, 8, TIMESTAMP '2024-07-17 09:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (20, 8, TIMESTAMP '2024-07-17 09:40:00', 'RETIRADO');

-- Sección 9: SO (seccion_id=9)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (6, 9, TIMESTAMP '2024-07-16 09:35:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (7, 9, TIMESTAMP '2024-07-16 10:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (18, 9, TIMESTAMP '2024-07-17 10:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (19, 9, TIMESTAMP '2024-07-17 10:40:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (21, 9, TIMESTAMP '2024-07-17 11:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (22, 9, TIMESTAMP '2024-07-18 08:00:00', 'COMPLETADO');

-- Sección 10: IA (seccion_id=10)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (8, 10, TIMESTAMP '2024-07-17 10:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (9, 10, TIMESTAMP '2024-07-17 11:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (10, 10, TIMESTAMP '2024-07-18 08:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (23, 10, TIMESTAMP '2024-07-18 09:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (24, 10, TIMESTAMP '2024-07-18 10:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (25, 10, TIMESTAMP '2024-07-18 11:15:00', 'COMPLETADO');

-- ==================== INSCRIPCIONES PERIODO 2025-1 (ACTIVO) ====================
-- Sección 11: Cálculo I - A (seccion_id=11)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 11, TIMESTAMP '2025-01-16 08:00:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (6, 11, TIMESTAMP '2025-01-16 08:30:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (9, 11, TIMESTAMP '2025-01-16 09:00:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (12, 11, TIMESTAMP '2025-01-16 09:30:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (15, 11, TIMESTAMP '2025-01-16 10:00:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (18, 11, TIMESTAMP '2025-01-16 10:30:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (21, 11, TIMESTAMP '2025-01-16 11:00:00', 'INSCRITO');

-- Sección 13: Programación I - A (seccion_id=13)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (4, 13, TIMESTAMP '2025-01-16 08:05:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (12, 13, TIMESTAMP '2025-01-16 09:35:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (15, 13, TIMESTAMP '2025-01-16 10:05:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (18, 13, TIMESTAMP '2025-01-16 10:35:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (19, 13, TIMESTAMP '2025-01-16 11:05:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (20, 13, TIMESTAMP '2025-01-17 08:00:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (21, 13, TIMESTAMP '2025-01-17 08:30:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (22, 13, TIMESTAMP '2025-01-17 09:00:00', 'INSCRITO');

-- Sección 14: BD I - A (seccion_id=14)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (2, 14, TIMESTAMP '2025-01-16 08:10:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (6, 14, TIMESTAMP '2025-01-16 09:40:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (7, 14, TIMESTAMP '2025-01-16 10:10:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (9, 14, TIMESTAMP '2025-01-16 10:40:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (10, 14, TIMESTAMP '2025-01-16 11:10:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (11, 14, TIMESTAMP '2025-01-17 08:10:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (13, 14, TIMESTAMP '2025-01-17 08:40:00', 'INSCRITO');

-- Sección 15: BD II - A (seccion_id=15) - cupo casi lleno
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 15, TIMESTAMP '2025-01-16 08:15:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (2, 15, TIMESTAMP '2025-01-16 08:45:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 15, TIMESTAMP '2025-01-16 09:15:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (4, 15, TIMESTAMP '2025-01-16 09:45:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (5, 15, TIMESTAMP '2025-01-16 10:15:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (14, 15, TIMESTAMP '2025-01-16 10:45:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (16, 15, TIMESTAMP '2025-01-16 11:15:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (17, 15, TIMESTAMP '2025-01-17 08:15:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (19, 15, TIMESTAMP '2025-01-17 08:45:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (20, 15, TIMESTAMP '2025-01-17 09:15:00', 'INSCRITO');

-- Sección 18: BD II - B (seccion_id=18) - cupo LLENO (0 disponible)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (7, 18, TIMESTAMP '2025-01-16 08:20:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (8, 18, TIMESTAMP '2025-01-16 08:50:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (10, 18, TIMESTAMP '2025-01-16 09:20:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (11, 18, TIMESTAMP '2025-01-16 09:50:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (13, 18, TIMESTAMP '2025-01-16 10:20:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (22, 18, TIMESTAMP '2025-01-16 10:50:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (23, 18, TIMESTAMP '2025-01-16 11:20:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (24, 18, TIMESTAMP '2025-01-17 08:20:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (25, 18, TIMESTAMP '2025-01-17 08:50:00', 'INSCRITO');

COMMIT;
