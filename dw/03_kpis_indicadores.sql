-- Indicadores estratégicos (KPIs) sobre el Data Warehouse.
-- Ejecutar como acme_school.

ALTER SESSION SET CURRENT_SCHEMA = acme_school;

-- ============================================================
-- KPI 1: TASA DE APROBACIÓN POR CURSO Y PERÍODO
-- Fórmula: estudiantes aprobados / total evaluados * 100
-- ============================================================

SELECT
    p.nombre AS periodo,
    c.nombre AS curso,
    COUNT(*) AS total_evaluados,
    SUM(CASE WHEN f.aprobado = 1 THEN 1 ELSE 0 END) AS total_aprobados,
    SUM(CASE WHEN f.aprobado = 0 THEN 1 ELSE 0 END) AS total_reprobados,
    ROUND(
        (SUM(CASE WHEN f.aprobado = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100,
        2
    ) AS tasa_aprobacion
FROM dw_fact_notas f
INNER JOIN dw_dim_curso c
    ON f.curso_key = c.curso_key
INNER JOIN dw_dim_periodo p
    ON f.periodo_key = p.periodo_key
GROUP BY
    p.nombre,
    c.nombre
ORDER BY
    p.nombre,
    tasa_aprobacion DESC;


-- ============================================================
-- KPI 2: PROMEDIO DE NOTAS POR CURSO
-- ============================================================

SELECT
    c.nombre AS curso,
    ROUND(AVG(f.promedio_nota), 2) AS promedio_general,
    MAX(f.nota_maxima) AS nota_maxima,
    MIN(f.nota_minima) AS nota_minima,
    SUM(f.cantidad_evaluaciones) AS total_evaluaciones
FROM dw_fact_notas f
INNER JOIN dw_dim_curso c
    ON f.curso_key = c.curso_key
GROUP BY
    c.nombre
ORDER BY
    promedio_general DESC;


-- ============================================================
-- KPI 3: PROMEDIO DE NOTAS POR DOCENTE
-- ============================================================

SELECT
    d.nombre_completo AS docente,
    ROUND(AVG(f.promedio_nota), 2) AS promedio_docente,
    COUNT(*) AS total_registros,
    SUM(f.cantidad_evaluaciones) AS total_evaluaciones
FROM dw_fact_notas f
INNER JOIN dw_dim_docente d
    ON f.docente_key = d.docente_key
GROUP BY
    d.nombre_completo
ORDER BY
    promedio_docente DESC;


-- ============================================================
-- KPI 4: INSCRIPCIONES POR PERÍODO
-- ============================================================

SELECT
    p.nombre AS periodo,
    SUM(f.cantidad_inscripciones) AS total_inscripciones
FROM dw_fact_inscripciones f
INNER JOIN dw_dim_periodo p
    ON f.periodo_key = p.periodo_key
GROUP BY
    p.nombre
ORDER BY
    p.nombre;


-- ============================================================
-- KPI 5: INSCRIPCIONES POR CURSO
-- ============================================================

SELECT
    c.nombre AS curso,
    SUM(f.cantidad_inscripciones) AS total_inscripciones
FROM dw_fact_inscripciones f
INNER JOIN dw_dim_curso c
    ON f.curso_key = c.curso_key
GROUP BY
    c.nombre
ORDER BY
    total_inscripciones DESC;


-- ============================================================
-- KPI 6: CARGA DOCENTE
-- Cantidad de inscripciones atendidas por cada docente
-- ============================================================

SELECT
    d.nombre_completo AS docente,
    SUM(f.cantidad_inscripciones) AS total_estudiantes_atendidos
FROM dw_fact_inscripciones f
INNER JOIN dw_dim_docente d
    ON f.docente_key = d.docente_key
GROUP BY
    d.nombre_completo
ORDER BY
    total_estudiantes_atendidos DESC;


-- ============================================================
-- KPI 7: RESUMEN GENERAL DEL DATA WAREHOUSE
-- ============================================================

SELECT 'Estudiantes en DW' AS indicador, COUNT(*) AS total
FROM dw_dim_estudiante
UNION ALL
SELECT 'Cursos en DW', COUNT(*)
FROM dw_dim_curso
UNION ALL
SELECT 'Docentes en DW', COUNT(*)
FROM dw_dim_docente
UNION ALL
SELECT 'Períodos en DW', COUNT(*)
FROM dw_dim_periodo
UNION ALL
SELECT 'Inscripciones en DW', COUNT(*)
FROM dw_fact_inscripciones
UNION ALL
SELECT 'Notas en DW', COUNT(*)
FROM dw_fact_notas;