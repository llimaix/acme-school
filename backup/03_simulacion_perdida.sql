-- Simulación controlada de pérdida: elimina inscripciones y notas
-- del período 2024-1 para luego recuperarlas (04_recuperacion.sql).
-- Ejecutar como acme_school. Requiere backup validado.

ALTER SESSION SET CURRENT_SCHEMA = acme_school;
SET SERVEROUTPUT ON;

-- ============================================================
-- PASO 1: VERIFICAR ESTADO ANTES DE LA PÉRDIDA
-- ============================================================

PROMPT === ESTADO ANTES DE LA SIMULACION ===

-- Conteo total de inscripciones del período 2024-1
SELECT COUNT(*) AS inscripciones_periodo_2024_1
FROM inscripcion i
JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = (SELECT periodo_id FROM periodo WHERE codigo = '2024-1');

-- Muestra de las inscripciones que vamos a "perder"
SELECT i.inscripcion_id,
       e.codigo  AS estudiante,
       c.nombre  AS curso,
       i.estado
FROM inscripcion i
JOIN estudiante e ON i.estudiante_id = e.estudiante_id
JOIN seccion s    ON i.seccion_id    = s.seccion_id
JOIN curso c      ON s.curso_id      = c.curso_id
JOIN periodo p    ON s.periodo_id    = p.periodo_id
WHERE p.codigo = '2024-1'
  AND ROWNUM <= 10
ORDER BY i.inscripcion_id;

-- Conteo de notas asociadas
SELECT COUNT(*) AS notas_periodo_2024_1
FROM nota n
JOIN inscripcion i ON n.inscripcion_id = i.inscripcion_id
JOIN seccion s     ON i.seccion_id     = s.seccion_id
WHERE s.periodo_id = (SELECT periodo_id FROM periodo WHERE codigo = '2024-1');

-- ============================================================
-- PASO 2: REGISTRAR PUNTO DE RECUPERACIÓN
-- Forzar un archive log switch para tener checkpoint conocido
-- Ejecutar como SYSDBA antes de la pérdida:
-- ============================================================

/*
-- Como SYSDBA:
ALTER SYSTEM SWITCH LOGFILE;
ALTER SYSTEM CHECKPOINT;

-- Anotar el SCN actual:
SELECT TIMESTAMP_TO_SCN(SYSTIMESTAMP) AS scn_pre_perdida FROM DUAL;
SELECT SYSTIMESTAMP AS hora_pre_perdida FROM DUAL;

-- Esto sirve como punto de referencia para SET UNTIL en RMAN
*/

-- ============================================================
-- PASO 3: SIMULAR LA PÉRDIDA DE DATOS
-- Eliminar todas las notas e inscripciones del período 2024-1
-- ============================================================

PROMPT === SIMULANDO PERDIDA DE DATOS ===

-- Eliminar notas del período 2024-1
DELETE FROM nota
WHERE inscripcion_id IN (
    SELECT i.inscripcion_id
    FROM inscripcion i
    JOIN seccion s ON i.seccion_id = s.seccion_id
    WHERE s.periodo_id = (SELECT periodo_id FROM periodo WHERE codigo = '2024-1')
);

-- Eliminar inscripciones del período 2024-1
DELETE FROM inscripcion
WHERE seccion_id IN (
    SELECT seccion_id FROM seccion
    WHERE periodo_id = (SELECT periodo_id FROM periodo WHERE codigo = '2024-1')
);

-- COMMIT: persiste la pérdida (los datos ya no se pueden recuperar
-- con un simple ROLLBACK)
COMMIT;

-- ============================================================
-- PASO 4: VERIFICAR QUE LOS DATOS SE PERDIERON
-- ============================================================

PROMPT === VERIFICACION DE PERDIDA ===

SELECT COUNT(*) AS inscripciones_despues
FROM inscripcion i
JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = (SELECT periodo_id FROM periodo WHERE codigo = '2024-1');
-- Resultado esperado: 0

SELECT COUNT(*) AS notas_despues
FROM nota n
JOIN inscripcion i ON n.inscripcion_id = i.inscripcion_id
JOIN seccion s     ON i.seccion_id     = s.seccion_id
WHERE s.periodo_id = (SELECT periodo_id FROM periodo WHERE codigo = '2024-1');
-- Resultado esperado: 0

-- Verificar también que el resto de datos sigue intacto
SELECT 'Periodo 2024-2' AS periodo, COUNT(*) AS inscripciones
FROM inscripcion i
JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = (SELECT periodo_id FROM periodo WHERE codigo = '2024-2')
UNION ALL
SELECT 'Periodo 2025-1', COUNT(*)
FROM inscripcion i
JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = (SELECT periodo_id FROM periodo WHERE codigo = '2025-1');
-- Estos deben mantener sus conteos originales

-- ============================================================
-- SIGUIENTE PASO
-- ============================================================
-- Continuar con backup/04_recuperacion.sql para restaurar
-- los datos perdidos usando alguna de estas opciones:
--   A) Flashback Table (más rápido, si está habilitado)
--   B) RMAN Point-in-Time Recovery (recovery completo)
--   C) Data Pump Import (desde export previo)

-- ============================================================
-- EVIDENCIA REQUERIDA PARA EL PDF
-- ============================================================
-- 1. Captura de los conteos ANTES de la pérdida
-- 2. Captura del DELETE ejecutándose
-- 3. Captura de los conteos DESPUÉS (debe ser 0)
-- 4. Captura del SCN/timestamp anotado para usar en T-028
