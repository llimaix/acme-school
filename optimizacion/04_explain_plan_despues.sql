-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 04_explain_plan_despues.sql
-- Descripción: EXPLAIN PLAN después de optimizar (comparación)
-- Responsable: Julian
-- Tarea: T-037
-- ============================================================

SET ECHO ON;
SET FEEDBACK ON;
SET TIMING ON;
SET LINESIZE 200;
SET PAGESIZE 100;

COLUMN PLAN_TABLE_OUTPUT FORMAT A180;

-- ============================================================
-- Limpieza únicamente del plan DESPUÉS
-- No se elimina el plan ANTES para poder compararlo.
-- ============================================================

DELETE FROM PLAN_TABLE
WHERE STATEMENT_ID = 'CONSULTA_CRITICA_01_DESPUES';

COMMIT;

-- ============================================================
-- CONSULTA CRÍTICA 01 - DESPUÉS DE OPTIMIZAR
-- ============================================================
-- Objetivo:
-- Ejecutar el EXPLAIN PLAN de la misma consulta crítica utilizada
-- antes de crear índices, para comparar costo, filas estimadas
-- y ruta de acceso.

EXPLAIN PLAN SET STATEMENT_ID = 'CONSULTA_CRITICA_01_DESPUES' FOR
SELECT
    p.nombre AS periodo,
    c.nombre AS curso,
    COUNT(i.inscripcion_id) AS total_inscripciones,
    ROUND(AVG(n.valor), 2) AS promedio_notas
FROM inscripcion i
INNER JOIN seccion s
    ON i.seccion_id = s.seccion_id
INNER JOIN curso c
    ON s.curso_id = c.curso_id
INNER JOIN periodo p
    ON s.periodo_id = p.periodo_id
LEFT JOIN nota n
    ON i.inscripcion_id = n.inscripcion_id
GROUP BY
    p.nombre,
    c.nombre
ORDER BY
    p.nombre,
    c.nombre;

-- ============================================================
-- Mostrar plan de ejecución después de optimizar
-- ============================================================

SELECT *
FROM TABLE(
    DBMS_XPLAN.DISPLAY(
        'PLAN_TABLE',
        'CONSULTA_CRITICA_01_DESPUES',
        'BASIC +ROWS +COST +BYTES +PREDICATE'
    )
);

-- ============================================================
-- Comparación de costo ANTES vs DESPUÉS
-- ============================================================

SELECT
    antes.statement_id AS consulta_antes,
    antes.cost AS costo_antes,
    despues.statement_id AS consulta_despues,
    despues.cost AS costo_despues,
    CASE
        WHEN antes.cost > 0 THEN
            ROUND(((antes.cost - despues.cost) / antes.cost) * 100, 2)
        ELSE
            0
    END AS mejora_porcentaje
FROM plan_table antes
INNER JOIN plan_table despues
    ON antes.id = despues.id
WHERE antes.statement_id = 'CONSULTA_CRITICA_01_ANTES'
  AND despues.statement_id = 'CONSULTA_CRITICA_01_DESPUES'
  AND antes.id = 0
  AND despues.id = 0;

-- ============================================================
-- Comparación de filas estimadas ANTES vs DESPUÉS
-- ============================================================

SELECT
    antes.statement_id AS consulta_antes,
    antes.cardinality AS filas_antes,
    despues.statement_id AS consulta_despues,
    despues.cardinality AS filas_despues
FROM plan_table antes
INNER JOIN plan_table despues
    ON antes.id = despues.id
WHERE antes.statement_id = 'CONSULTA_CRITICA_01_ANTES'
  AND despues.statement_id = 'CONSULTA_CRITICA_01_DESPUES'
  AND antes.id = 0
  AND despues.id = 0;

-- ============================================================
-- Verificación de índices disponibles
-- ============================================================

SELECT
    index_name,
    table_name,
    status
FROM user_indexes
WHERE index_name IN (
    'IDX_INSCRIPCION_SECCION',
    'IDX_NOTA_INSCRIPCION',
    'IDX_SECCION_CURSO_PERIODO',
    'IDX_INSCRIPCION_ESTUDIANTE',
    'IDX_SECCION_DOCENTE'
)
ORDER BY table_name, index_name;

-- ============================================================
-- Fin del script
-- ============================================================

SET TIMING OFF;