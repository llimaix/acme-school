-- Solución al deadlock: orden fijo de locks (LEAST/GREATEST) y SELECT FOR UPDATE.

-- ============================================================
-- CAUSA RAÍZ DEL DEADLOCK
-- ============================================================
-- En T-016, ambas sesiones modificaban las mismas secciones
-- pero en ORDEN INVERSO. Resultado: ciclo de espera mutua.
--
-- Sesión A:  R1 → R2
-- Sesión B:  R2 → R1   ← inverso → DEADLOCK

-- ============================================================
-- SOLUCIÓN 1: ORDEN FIJO DE LOCKS
-- ============================================================
-- Regla: SIEMPRE bloquear los recursos en el mismo orden,
--        típicamente por PK ascendente.
--
-- De esta forma, si dos transacciones quieren modificar las
-- mismas filas, ambas las pedirán en el mismo orden y solo
-- una esperará (sin formar ciclo).

CREATE OR REPLACE PROCEDURE pkg_inscripcion_doble_seccion(
    p_estudiante_id  IN NUMBER,
    p_seccion_id_1   IN NUMBER,
    p_seccion_id_2   IN NUMBER
) AS
    v_min_id NUMBER;
    v_max_id NUMBER;
    v_cupo   NUMBER;
BEGIN
    -- Calcular el orden FIJO: siempre menor primero
    v_min_id := LEAST(p_seccion_id_1, p_seccion_id_2);
    v_max_id := GREATEST(p_seccion_id_1, p_seccion_id_2);

    -- 1. SELECT FOR UPDATE en orden ascendente
    SELECT cupo_disponible INTO v_cupo
    FROM seccion WHERE seccion_id = v_min_id FOR UPDATE;

    SELECT cupo_disponible INTO v_cupo
    FROM seccion WHERE seccion_id = v_max_id FOR UPDATE;

    -- 2. Realizar updates (ya tenemos los locks en orden seguro)
    UPDATE seccion SET cupo_disponible = cupo_disponible - 1
    WHERE seccion_id = v_min_id;

    UPDATE seccion SET cupo_disponible = cupo_disponible - 1
    WHERE seccion_id = v_max_id;

    INSERT INTO inscripcion (estudiante_id, seccion_id, estado)
    VALUES (p_estudiante_id, v_min_id, 'INSCRITO');

    INSERT INTO inscripcion (estudiante_id, seccion_id, estado)
    VALUES (p_estudiante_id, v_max_id, 'INSCRITO');

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END pkg_inscripcion_doble_seccion;
/

-- ============================================================
-- SOLUCIÓN 2: SELECT FOR UPDATE NOWAIT
-- ============================================================
-- Si no se puede obtener el lock inmediatamente,
-- en lugar de esperar (y arriesgar deadlock), falla rápido
-- con ORA-00054 y la lógica de aplicación reintenta.

-- Ejemplo de uso en sesión A:
-- BEGIN
--   FOR rec IN (SELECT seccion_id FROM seccion
--               WHERE seccion_id IN (11, 12)
--               ORDER BY seccion_id  -- importante el ORDER BY
--               FOR UPDATE NOWAIT) LOOP
--     UPDATE seccion SET cupo_disponible = cupo_disponible - 1
--     WHERE seccion_id = rec.seccion_id;
--   END LOOP;
--   COMMIT;
-- EXCEPTION
--   WHEN OTHERS THEN
--     IF SQLCODE = -54 THEN
--       DBMS_OUTPUT.PUT_LINE('Recurso ocupado, reintentar mas tarde');
--     END IF;
--     ROLLBACK;
-- END;
-- /

-- ============================================================
-- SOLUCIÓN 3: REDUCIR ALCANCE TRANSACCIONAL
-- ============================================================
-- Hacer transacciones más cortas. Cuanto menos tiempo se
-- mantenga un lock, menor probabilidad de deadlock.
--
-- En lugar de bloquear muchos recursos en una sola transacción,
-- dividir en transacciones independientes cuando el negocio lo permita.

-- ============================================================
-- VERIFICACION DE LA SOLUCION
-- ============================================================
-- Ejecutar el procedimiento desde DOS sesiones en paralelo
-- con secciones cruzadas. Ya NO debe ocurrir deadlock:
--
-- Sesión A:  EXEC pkg_inscripcion_doble_seccion(1, 11, 12);
-- Sesión B:  EXEC pkg_inscripcion_doble_seccion(2, 12, 11);
--
-- Ambas internamente piden locks en orden ascendente (11 → 12).
-- La segunda en llegar espera, no entra en deadlock.

-- ============================================================
-- RESUMEN
-- ============================================================
-- Causa:    Lock ordering inverso entre sesiones concurrentes
-- Solución elegida: Orden fijo de locks (LEAST/GREATEST + FOR UPDATE)
-- Resultado: Ya no hay ORA-00060, una sesión espera y prosigue
