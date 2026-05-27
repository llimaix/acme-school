-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 05_reescritura_sql.sql
-- Descripción: Optimización por reescritura de consulta SQL
-- Responsable: Julian
-- Tarea: T-038
-- ============================================================

SET ECHO ON;
SET FEEDBACK ON;
SET TIMING ON;
SET LINESIZE 200;
SET PAGESIZE 100;

COLUMN PLAN_TABLE_OUTPUT FORMAT A180;

-- ============================================================
-- Objetivo:
-- Demostrar una mejora de rendimiento reescribiendo una consulta SQL.
--
-- Consulta original:
--   Usa subconsultas correlacionadas para calcular totales y promedios.
--
-- Consulta optimizada:
--   Usa JOIN, LEFT JOIN y GROUP BY para procesar los datos en una sola pasada.
--
-- Nota:
--   Se usa el último PERIODO_ID existente en SECCION, para evitar tomar
--   un período que exista en PERIODO pero que aún no tenga secciones cargadas.
-- ============================================================

-- ============================================================
-- Limpieza de planes anteriores
-- ============================================================

DELETE FROM PLAN_TABLE
WHERE STATEMENT_ID IN (
    'REESCRITURA_ORIGINAL',
    'REESCRITURA_OPTIMIZADA'
);

COMMIT;

-- ============================================================
-- Verificar período utilizado para la prueba
-- ============================================================

SELECT
    MAX(sx.periodo_id) AS periodo_usado
FROM seccion sx;

-- ============================================================
-- CONSULTA ORIGINAL
-- ============================================================
-- Problema:
-- Esta consulta utiliza subconsultas correlacionadas.
-- Por cada curso y período, Oracle debe volver a consultar
-- INSCRIPCION, SECCION y NOTA para calcular los resultados.
--
-- Esto puede ser ineficiente cuando existen muchos registros.
-- ============================================================

EXPLAIN PLAN SET STATEMENT_ID = 'REESCRITURA_ORIGINAL' FOR
SELECT DISTINCT
    p.nombre AS periodo,
    c.nombre AS curso,

    (
        SELECT COUNT(i.inscripcion_id)
        FROM inscripcion i
        INNER JOIN seccion s2
            ON i.seccion_id = s2.seccion_id
        WHERE s2.curso_id = c.curso_id
          AND s2.periodo_id = p.periodo_id
    ) AS total_inscripciones,

    (
        SELECT ROUND(AVG(n.valor), 2)
        FROM nota n
        INNER JOIN inscripcion i2
            ON n.inscripcion_id = i2.inscripcion_id
        INNER JOIN seccion s3
            ON i2.seccion_id = s3.seccion_id
        WHERE s3.curso_id = c.curso_id
          AND s3.periodo_id = p.periodo_id
    ) AS promedio_notas

FROM curso c
INNER JOIN seccion s_base
    ON c.curso_id = s_base.curso_id
INNER JOIN periodo p
    ON s_base.periodo_id = p.periodo_id
WHERE p.periodo_id = (
    SELECT MAX(sx.periodo_id)
    FROM seccion sx
)
ORDER BY
    p.nombre,
    c.nombre;

-- ============================================================
-- Mostrar plan de la consulta original
-- ============================================================

SELECT *
FROM TABLE(
    DBMS_XPLAN.DISPLAY(
        'PLAN_TABLE',
        'REESCRITURA_ORIGINAL',
        'BASIC +ROWS +COST +BYTES +PREDICATE'
    )
);

-- ============================================================
-- CONSULTA OPTIMIZADA
-- ============================================================
-- Mejora aplicada:
-- Se reemplazan las subconsultas correlacionadas por JOIN,
-- LEFT JOIN y GROUP BY.
--
-- Ventajas:
--   - Menor repetición de lecturas.
--   - Mejor uso de los índices creados.
--   - Agrupación más eficiente.
--   - Consulta más clara y mantenible.
-- ============================================================

EXPLAIN PLAN SET STATEMENT_ID = 'REESCRITURA_OPTIMIZADA' FOR
SELECT
    p.nombre AS periodo,
    c.nombre AS curso,
    COUNT(DISTINCT i.inscripcion_id) AS total_inscripciones,
    ROUND(AVG(n.valor), 2) AS promedio_notas
FROM periodo p
INNER JOIN seccion s
    ON p.periodo_id = s.periodo_id
INNER JOIN curso c
    ON s.curso_id = c.curso_id
LEFT JOIN inscripcion i
    ON s.seccion_id = i.seccion_id
LEFT JOIN nota n
    ON i.inscripcion_id = n.inscripcion_id
WHERE p.periodo_id = (
    SELECT MAX(sx.periodo_id)
    FROM seccion sx
)
GROUP BY
    p.nombre,
    c.nombre
ORDER BY
    p.nombre,
    c.nombre;

-- ============================================================
-- Mostrar plan de la consulta optimizada
-- ============================================================

SELECT *
FROM TABLE(
    DBMS_XPLAN.DISPLAY(
        'PLAN_TABLE',
        'REESCRITURA_OPTIMIZADA',
        'BASIC +ROWS +COST +BYTES +PREDICATE'
    )
);

-- ============================================================
-- Comparación de costo entre consulta original y optimizada
-- ============================================================

SELECT
    original.statement_id AS consulta_original,
    original.cost AS costo_original,
    optimizada.statement_id AS consulta_optimizada,
    optimizada.cost AS costo_optimizado,
    CASE
        WHEN original.cost > 0 THEN
            ROUND(((original.cost - optimizada.cost) / original.cost) * 100, 2)
        ELSE
            0
    END AS mejora_porcentaje
FROM plan_table original
INNER JOIN plan_table optimizada
    ON original.id = optimizada.id
WHERE original.statement_id = 'REESCRITURA_ORIGINAL'
  AND optimizada.statement_id = 'REESCRITURA_OPTIMIZADA'
  AND original.id = 0
  AND optimizada.id = 0;

-- ============================================================
-- Comparación de filas estimadas
-- ============================================================

SELECT
    original.statement_id AS consulta_original,
    original.cardinality AS filas_original,
    optimizada.statement_id AS consulta_optimizada,
    optimizada.cardinality AS filas_optimizadas
FROM plan_table original
INNER JOIN plan_table optimizada
    ON original.id = optimizada.id
WHERE original.statement_id = 'REESCRITURA_ORIGINAL'
  AND optimizada.statement_id = 'REESCRITURA_OPTIMIZADA'
  AND original.id = 0
  AND optimizada.id = 0;

-- ============================================================
-- Ejecución de consulta original para validar resultado
-- ============================================================

SELECT DISTINCT
    p.nombre AS periodo,
    c.nombre AS curso,

    (
        SELECT COUNT(i.inscripcion_id)
        FROM inscripcion i
        INNER JOIN seccion s2
            ON i.seccion_id = s2.seccion_id
        WHERE s2.curso_id = c.curso_id
          AND s2.periodo_id = p.periodo_id
    ) AS total_inscripciones,

    (
        SELECT ROUND(AVG(n.valor), 2)
        FROM nota n
        INNER JOIN inscripcion i2
            ON n.inscripcion_id = i2.inscripcion_id
        INNER JOIN seccion s3
            ON i2.seccion_id = s3.seccion_id
        WHERE s3.curso_id = c.curso_id
          AND s3.periodo_id = p.periodo_id
    ) AS promedio_notas

FROM curso c
INNER JOIN seccion s_base
    ON c.curso_id = s_base.curso_id
INNER JOIN periodo p
    ON s_base.periodo_id = p.periodo_id
WHERE p.periodo_id = (
    SELECT MAX(sx.periodo_id)
    FROM seccion sx
)
ORDER BY
    p.nombre,
    c.nombre;

-- ============================================================
-- Ejecución de consulta optimizada para validar resultado
-- ============================================================

SELECT
    p.nombre AS periodo,
    c.nombre AS curso,
    COUNT(DISTINCT i.inscripcion_id) AS total_inscripciones,
    ROUND(AVG(n.valor), 2) AS promedio_notas
FROM periodo p
INNER JOIN seccion s
    ON p.periodo_id = s.periodo_id
INNER JOIN curso c
    ON s.curso_id = c.curso_id
LEFT JOIN inscripcion i
    ON s.seccion_id = i.seccion_id
LEFT JOIN nota n
    ON i.inscripcion_id = n.inscripcion_id
WHERE p.periodo_id = (
    SELECT MAX(sx.periodo_id)
    FROM seccion sx
)
GROUP BY
    p.nombre,
    c.nombre
ORDER BY
    p.nombre,
    c.nombre;

SET TIMING OFF;