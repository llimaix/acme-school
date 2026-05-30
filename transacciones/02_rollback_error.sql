-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 02_rollback_error.sql
-- Responsable: Wuili
-- Tarea: T-013
-- Descripción: Demostración de ROLLBACK ante error controlado.
--   3 escenarios:
--     A) Cupo lleno
--     B) Inscripción duplicada
--     C) Período cerrado
--   En todos los casos: NO debe quedar ningún cambio parcial.
-- Ejecutar como: acme_school
-- ============================================================

ALTER SESSION SET CURRENT_SCHEMA = acme_school;
SET SERVEROUTPUT ON;

-- ============================================================
-- ESCENARIO A: CUPO LLENO
-- Sección con cupo_disponible = 0 (BD II - 2025-1, sección B)
-- ============================================================

PROMPT === ESCENARIO A: CUPO LLENO ===
PROMPT Estado ANTES:

SELECT s.seccion_id, c.nombre AS curso, s.codigo_seccion,
       s.cupo_maximo, s.cupo_disponible
FROM seccion s
JOIN curso c   ON s.curso_id   = c.curso_id
JOIN periodo p ON s.periodo_id = p.periodo_id
WHERE c.codigo = 'BD-201' AND p.codigo = '2025-1' AND s.codigo_seccion = 'B';

DECLARE
    v_estudiante_id NUMBER;
    v_seccion_id    NUMBER;
    v_cupo          NUMBER;
BEGIN
    SELECT estudiante_id INTO v_estudiante_id
    FROM estudiante WHERE codigo = 'EST-001';

    SELECT s.seccion_id, s.cupo_disponible INTO v_seccion_id, v_cupo
    FROM seccion s
    JOIN curso c   ON s.curso_id   = c.curso_id
    JOIN periodo p ON s.periodo_id = p.periodo_id
    WHERE c.codigo = 'BD-201' AND p.codigo = '2025-1' AND s.codigo_seccion = 'B';

    -- Operación 1: INSERT (puede fallar antes de UPDATE)
    INSERT INTO inscripcion (estudiante_id, seccion_id, estado)
    VALUES (v_estudiante_id, v_seccion_id, 'INSCRITO');

    DBMS_OUTPUT.PUT_LINE('INSERT realizado (parcialmente)');

    -- Validación: cupo lleno → forzar error
    IF v_cupo <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'No hay cupo disponible');
    END IF;

    -- Operación 2: nunca se ejecuta porque ya levantó error
    UPDATE seccion SET cupo_disponible = cupo_disponible - 1
    WHERE seccion_id = v_seccion_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ROLLBACK ejecutado: ' || SQLERRM);
END;
/

PROMPT Estado DESPUES (debe ser idéntico al de antes):

SELECT s.seccion_id, c.nombre AS curso, s.codigo_seccion,
       s.cupo_maximo, s.cupo_disponible
FROM seccion s
JOIN curso c   ON s.curso_id   = c.curso_id
JOIN periodo p ON s.periodo_id = p.periodo_id
WHERE c.codigo = 'BD-201' AND p.codigo = '2025-1' AND s.codigo_seccion = 'B';

-- ============================================================
-- ESCENARIO B: INSCRIPCION DUPLICADA
-- El estudiante ya está inscrito en la sección
-- ============================================================

PROMPT === ESCENARIO B: INSCRIPCION DUPLICADA ===

DECLARE
    v_estudiante_id NUMBER;
    v_seccion_id    NUMBER;
BEGIN
    SELECT estudiante_id INTO v_estudiante_id
    FROM estudiante WHERE codigo = 'EST-001';

    SELECT s.seccion_id INTO v_seccion_id
    FROM seccion s
    JOIN curso c   ON s.curso_id   = c.curso_id
    JOIN periodo p ON s.periodo_id = p.periodo_id
    WHERE c.codigo = 'BD-201' AND p.codigo = '2025-1' AND s.codigo_seccion = 'A';

    -- INSERT que viola UNIQUE constraint (uk_inscripcion)
    INSERT INTO inscripcion (estudiante_id, seccion_id, estado)
    VALUES (v_estudiante_id, v_seccion_id, 'INSCRITO');

    -- UPDATE: nunca se ejecuta
    UPDATE seccion SET cupo_disponible = cupo_disponible - 1
    WHERE seccion_id = v_seccion_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ROLLBACK ejecutado: ' || SQLERRM);
END;
/

-- ============================================================
-- ESCENARIO C: PERIODO CERRADO
-- Intentar inscribir en un período con estado CERRADO
-- ============================================================

PROMPT === ESCENARIO C: PERIODO CERRADO ===

DECLARE
    v_estudiante_id   NUMBER;
    v_seccion_id      NUMBER;
    v_estado_periodo  VARCHAR2(20);
BEGIN
    SELECT estudiante_id INTO v_estudiante_id
    FROM estudiante WHERE codigo = 'EST-005';

    -- Sección de período 2024-1 (CERRADO)
    SELECT s.seccion_id, p.estado INTO v_seccion_id, v_estado_periodo
    FROM seccion s
    JOIN curso c   ON s.curso_id   = c.curso_id
    JOIN periodo p ON s.periodo_id = p.periodo_id
    WHERE c.codigo = 'MAT-101' AND p.codigo = '2024-1' AND s.codigo_seccion = 'A';

    INSERT INTO inscripcion (estudiante_id, seccion_id, estado)
    VALUES (v_estudiante_id, v_seccion_id, 'INSCRITO');

    DBMS_OUTPUT.PUT_LINE('INSERT realizado (parcialmente)');

    IF v_estado_periodo != 'ACTIVO' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Periodo cerrado, no se permite inscripcion');
    END IF;

    UPDATE seccion SET cupo_disponible = cupo_disponible - 1
    WHERE seccion_id = v_seccion_id;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ROLLBACK ejecutado: ' || SQLERRM);
END;
/

PROMPT === FIN: ROLLBACK demostrado en 3 escenarios ===
PROMPT Atomicidad garantizada: ningun cambio parcial persistio
