-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 04_insert_inscripciones_notas.sql
-- Descripción: Inscripciones y notas para todos los períodos
-- Responsable: Luis (completado por Luis ante ausencia de Julian)
-- Tarea: T-009
-- Ejecutar como: acme_school
-- ============================================================

-- ==================== INSCRIPCIONES PERIODO 2024-1 (CERRADO) ====================
-- Sección 1: Cálculo I
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 1, TIMESTAMP '2024-01-16 08:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (2, 1, TIMESTAMP '2024-01-16 09:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 1, TIMESTAMP '2024-01-16 10:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (4, 1, TIMESTAMP '2024-01-16 10:45:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (5, 1, TIMESTAMP '2024-01-16 11:30:00', 'RETIRADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (6, 1, TIMESTAMP '2024-01-17 08:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (7, 1, TIMESTAMP '2024-01-17 09:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (8, 1, TIMESTAMP '2024-01-17 10:00:00', 'COMPLETADO');

-- Sección 2: Programación I
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 2, TIMESTAMP '2024-01-16 08:35:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (2, 2, TIMESTAMP '2024-01-16 09:20:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 2, TIMESTAMP '2024-01-16 10:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (9, 2, TIMESTAMP '2024-01-17 08:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (10, 2, TIMESTAMP '2024-01-17 09:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (11, 2, TIMESTAMP '2024-01-17 10:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (13, 2, TIMESTAMP '2024-01-18 09:00:00', 'COMPLETADO');

-- Sección 3: BD I
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 3, TIMESTAMP '2024-01-16 08:40:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (4, 3, TIMESTAMP '2024-01-16 10:50:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (5, 3, TIMESTAMP '2024-01-16 11:35:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (14, 3, TIMESTAMP '2024-01-17 08:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (15, 3, TIMESTAMP '2024-01-17 09:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (16, 3, TIMESTAMP '2024-01-17 10:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (17, 3, TIMESTAMP '2024-01-18 08:00:00', 'COMPLETADO');

-- Sección 4: Redes
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (6, 4, TIMESTAMP '2024-01-17 08:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (7, 4, TIMESTAMP '2024-01-17 09:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (18, 4, TIMESTAMP '2024-01-17 10:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (19, 4, TIMESTAMP '2024-01-18 08:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (20, 4, TIMESTAMP '2024-01-18 09:05:00', 'COMPLETADO');

-- Sección 5: Estadística
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (8, 5, TIMESTAMP '2024-01-17 10:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (9, 5, TIMESTAMP '2024-01-17 11:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (10, 5, TIMESTAMP '2024-01-18 08:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (21, 5, TIMESTAMP '2024-01-18 09:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (22, 5, TIMESTAMP '2024-01-18 10:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (23, 5, TIMESTAMP '2024-01-19 08:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (24, 5, TIMESTAMP '2024-01-19 09:00:00', 'RETIRADO');

-- ==================== INSCRIPCIONES PERIODO 2024-2 (CERRADO) ====================
-- Sección 6: Álgebra Lineal
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 6, TIMESTAMP '2024-07-16 08:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (2, 6, TIMESTAMP '2024-07-16 08:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 6, TIMESTAMP '2024-07-16 09:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (6, 6, TIMESTAMP '2024-07-16 09:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (7, 6, TIMESTAMP '2024-07-16 10:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (11, 6, TIMESTAMP '2024-07-16 10:30:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (13, 6, TIMESTAMP '2024-07-16 11:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (14, 6, TIMESTAMP '2024-07-17 08:00:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (25, 6, TIMESTAMP '2024-07-17 08:30:00', 'RETIRADO');

-- Sección 7: Estructuras de Datos
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 7, TIMESTAMP '2024-07-16 08:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (2, 7, TIMESTAMP '2024-07-16 08:35:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 7, TIMESTAMP '2024-07-16 09:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (9, 7, TIMESTAMP '2024-07-16 09:35:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (10, 7, TIMESTAMP '2024-07-16 10:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (11, 7, TIMESTAMP '2024-07-16 10:35:00', 'COMPLETADO');

-- Sección 8: BD II
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 8, TIMESTAMP '2024-07-16 08:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (4, 8, TIMESTAMP '2024-07-16 10:55:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (5, 8, TIMESTAMP '2024-07-16 11:40:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (14, 8, TIMESTAMP '2024-07-17 08:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (16, 8, TIMESTAMP '2024-07-17 08:40:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (17, 8, TIMESTAMP '2024-07-17 09:10:00', 'COMPLETADO');

-- Sección 9: SO
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (6, 9, TIMESTAMP '2024-07-16 09:35:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (7, 9, TIMESTAMP '2024-07-16 10:05:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (18, 9, TIMESTAMP '2024-07-17 10:10:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (19, 9, TIMESTAMP '2024-07-17 10:40:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (21, 9, TIMESTAMP '2024-07-17 11:10:00', 'COMPLETADO');

-- Sección 10: IA
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (8, 10, TIMESTAMP '2024-07-17 10:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (9, 10, TIMESTAMP '2024-07-17 11:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (10, 10, TIMESTAMP '2024-07-18 08:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (23, 10, TIMESTAMP '2024-07-18 09:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (24, 10, TIMESTAMP '2024-07-18 10:15:00', 'COMPLETADO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (25, 10, TIMESTAMP '2024-07-18 11:15:00', 'COMPLETADO');

-- ==================== INSCRIPCIONES PERIODO 2025-1 (ACTIVO) ====================
-- Sección 11: Cálculo I - A
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 11, TIMESTAMP '2025-01-16 08:00:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (6, 11, TIMESTAMP '2025-01-16 08:30:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (9, 11, TIMESTAMP '2025-01-16 09:00:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (12, 11, TIMESTAMP '2025-01-16 09:30:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (15, 11, TIMESTAMP '2025-01-16 10:00:00', 'INSCRITO');

-- Sección 15: BD II - A (cupo bajo)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (1, 15, TIMESTAMP '2025-01-16 08:15:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (2, 15, TIMESTAMP '2025-01-16 08:45:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (3, 15, TIMESTAMP '2025-01-16 09:15:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (4, 15, TIMESTAMP '2025-01-16 09:45:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (5, 15, TIMESTAMP '2025-01-16 10:15:00', 'INSCRITO');

-- Sección 18: BD II - B (CUPO LLENO - para demo ROLLBACK)
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (7, 18, TIMESTAMP '2025-01-16 08:20:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (8, 18, TIMESTAMP '2025-01-16 08:50:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (10, 18, TIMESTAMP '2025-01-16 09:20:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (11, 18, TIMESTAMP '2025-01-16 09:50:00', 'INSCRITO');
INSERT INTO inscripcion (estudiante_id, seccion_id, fecha_inscripcion, estado) VALUES (13, 18, TIMESTAMP '2025-01-16 10:20:00', 'INSCRITO');

COMMIT;
