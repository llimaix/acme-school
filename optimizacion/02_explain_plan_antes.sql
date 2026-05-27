-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 02_explain_plan_antes.sql
-- Descripción: EXPLAIN PLAN antes de optimizar
-- Responsable: Julián
-- Tarea: T-034
-- ============================================================

SET ECHO ON;
SET FEEDBACK ON;
SET TIMING ON;
SET LINESIZE 200;
SET PAGESIZE 100;

COLUMN PLAN_TABLE_OUTPUT FORMAT A180;

-- ============================================================
-- Limpieza de planes anteriores
-- ============================================================

DELETE FROM PLAN_TABLE
WHERE STATEMENT_ID = 'CONSULTA_CRITICA_01_ANTES';

COMMIT;

-- ============================================================
-- CONSULTA CRÍTICA 01 - ANTES DE OPTIMIZAR
-- ============================================================
-- Objetivo:
-- Analizar el rendimiento académico agrupado por período y curso.
--
-- Esta consulta es crítica porque realiza JOIN entre INSCRIPCION,
-- SECCION, CURSO, PERIODO y NOTA. Además agrupa datos y calcula
-- promedios, por lo que puede volverse lenta con muchos registros.

EXPLAIN PLAN SET STATEMENT_ID = 'CONSULTA_CRITICA_01_ANTES' FOR
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
-- Mostrar plan de ejecución antes de optimizar
-- ============================================================

SELECT *
FROM TABLE(
    DBMS_XPLAN.DISPLAY(
        'PLAN_TABLE',
        'CONSULTA_CRITICA_01_ANTES',
        'BASIC +ROWS +COST +BYTES +PREDICATE'
    )
);

-- ============================================================
-- Fin del script
-- ============================================================

SET TIMING OFF;