-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 01_commit_exitoso.sql
-- Responsable: Wuili
-- Tarea: T-012
-- Descripción: Demostración de COMMIT explícito en una operación
--   crítica (inscripción de estudiante). Demuestra atomicidad
--   y persistencia de cambios.
-- Ejecutar como: acme_school
-- ============================================================

ALTER SESSION SET CURRENT_SCHEMA = acme_school;
SET SERVEROUTPUT ON;

-- ==================== ESTADO ANTES ====================
PROMPT === ESTADO ANTES DE LA TRANSACCION ===

-- Datos del estudiante a inscribir
SELECT estudiante_id, codigo, nombre || ' ' || apellido AS nombre, estado
FROM estudiante
WHERE codigo = 'EST-002';

-- Cupo de la sección destino (Cálculo I - 2025-1, sección A)
SELECT s.seccion_id, c.nombre AS curso, p.codigo AS periodo,
       s.codigo_seccion, s.cupo_maximo, s.cupo_disponible
FROM seccion s
JOIN curso c   ON s.curso_id   = c.curso_id
JOIN periodo p ON s.periodo_id = p.periodo_id
WHERE c.codigo = 'MAT-101' AND p.codigo = '2025-1' AND s.codigo_seccion = 'A';

-- Conteo previo de inscripciones del estudiante
SELECT COUNT(*) AS inscripciones_previas
FROM inscripcion
WHERE estudiante_id = (SELECT estudiante_id FROM estudiante WHERE codigo = 'EST-002');

-- ==================== TRANSACCION ====================
PROMPT === EJECUTANDO TRANSACCION CON COMMIT ===

DECLARE
    v_estudiante_id NUMBER;
    v_seccion_id    NUMBER;
    v_inscripcion_id NUMBER;
BEGIN
    -- Obtener IDs
    SELECT estudiante_id INTO v_estudiante_id
    FROM estudiante WHERE codigo = 'EST-002';

    SELECT s.seccion_id INTO v_seccion_id
    FROM seccion s
    JOIN curso c   ON s.curso_id   = c.curso_id
    JOIN periodo p ON s.periodo_id = p.periodo_id
    WHERE c.codigo = 'MAT-101' AND p.codigo = '2025-1' AND s.codigo_seccion = 'A';

    -- Operación 1: Insertar inscripción
    INSERT INTO inscripcion (estudiante_id, seccion_id, estado)
    VALUES (v_estudiante_id, v_seccion_id, 'INSCRITO')
    RETURNING inscripcion_id INTO v_inscripcion_id;

    DBMS_OUTPUT.PUT_LINE('Inscripcion creada con ID: ' || v_inscripcion_id);

    -- Operación 2: Decrementar cupo
    UPDATE seccion
    SET cupo_disponible = cupo_disponible - 1
    WHERE seccion_id = v_seccion_id;

    DBMS_OUTPUT.PUT_LINE('Cupo decrementado en 1');

    -- COMMIT EXPLICITO: persistir ambos cambios atómicamente
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('COMMIT exitoso - Cambios persistidos');
END;
/

-- ==================== ESTADO DESPUES ====================
PROMPT === ESTADO DESPUES DE COMMIT ===

-- Verificar inscripción creada
SELECT i.inscripcion_id, e.codigo AS estudiante, c.nombre AS curso,
       i.estado, i.fecha_inscripcion
FROM inscripcion i
JOIN estudiante e ON i.estudiante_id = e.estudiante_id
JOIN seccion s    ON i.seccion_id    = s.seccion_id
JOIN curso c      ON s.curso_id      = c.curso_id
JOIN periodo p    ON s.periodo_id    = p.periodo_id
WHERE e.codigo = 'EST-002'
  AND c.codigo = 'MAT-101'
  AND p.codigo = '2025-1'
  AND s.codigo_seccion = 'A';

-- Verificar nuevo cupo
SELECT s.seccion_id, c.nombre AS curso, p.codigo AS periodo,
       s.cupo_maximo, s.cupo_disponible
FROM seccion s
JOIN curso c   ON s.curso_id   = c.curso_id
JOIN periodo p ON s.periodo_id = p.periodo_id
WHERE c.codigo = 'MAT-101' AND p.codigo = '2025-1' AND s.codigo_seccion = 'A';

PROMPT === FIN: COMMIT exitoso, atomicidad demostrada ===
