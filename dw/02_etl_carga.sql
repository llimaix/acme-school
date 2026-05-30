-- ETL desde el modelo operacional hacia el Data Warehouse.
-- Ejecutar como acme_school.

ALTER SESSION SET CURRENT_SCHEMA = acme_school;

-- ============================================================
-- 1. LIMPIEZA DE TABLAS DW
-- Primero se limpian las tablas de hechos y luego dimensiones
-- ============================================================

DELETE FROM dw_fact_notas;
DELETE FROM dw_fact_inscripciones;

DELETE FROM dw_dim_estudiante;
DELETE FROM dw_dim_curso;
DELETE FROM dw_dim_docente;
DELETE FROM dw_dim_periodo;

COMMIT;

-- ============================================================
-- 2. CARGA DE DIMENSIONES
-- ============================================================

-- =========================
-- DIMENSION ESTUDIANTE
-- =========================
INSERT INTO dw_dim_estudiante (
    estudiante_key,
    estudiante_id,
    codigo,
    nombre_completo,
    estado,
    fecha_carga
)
SELECT
    ROW_NUMBER() OVER (ORDER BY estudiante_id) AS estudiante_key,
    estudiante_id,
    codigo,
    nombre || ' ' || apellido AS nombre_completo,
    estado,
    SYSTIMESTAMP
FROM estudiante;

-- =========================
-- DIMENSION CURSO
-- =========================
INSERT INTO dw_dim_curso (
    curso_key,
    curso_id,
    codigo,
    nombre,
    creditos,
    fecha_carga
)
SELECT
    ROW_NUMBER() OVER (ORDER BY curso_id) AS curso_key,
    curso_id,
    codigo,
    nombre,
    creditos,
    SYSTIMESTAMP
FROM curso;

-- =========================
-- DIMENSION DOCENTE
-- =========================
INSERT INTO dw_dim_docente (
    docente_key,
    docente_id,
    codigo,
    nombre_completo,
    especialidad,
    fecha_carga
)
SELECT
    ROW_NUMBER() OVER (ORDER BY docente_id) AS docente_key,
    docente_id,
    codigo,
    nombre || ' ' || apellido AS nombre_completo,
    especialidad,
    SYSTIMESTAMP
FROM docente;

-- =========================
-- DIMENSION PERIODO
-- =========================
INSERT INTO dw_dim_periodo (
    periodo_key,
    periodo_id,
    codigo,
    nombre,
    anio,
    estado,
    fecha_carga
)
SELECT
    ROW_NUMBER() OVER (ORDER BY periodo_id) AS periodo_key,
    periodo_id,
    codigo,
    nombre,
    EXTRACT(YEAR FROM fecha_inicio) AS anio,
    estado,
    SYSTIMESTAMP
FROM periodo;

COMMIT;

-- ============================================================
-- 3. CARGA DE TABLA DE HECHOS: INSCRIPCIONES
-- ============================================================

INSERT INTO dw_fact_inscripciones (
    inscripcion_key,
    estudiante_key,
    curso_key,
    docente_key,
    periodo_key,
    cantidad_inscripciones
)
SELECT
    ROW_NUMBER() OVER (ORDER BY i.inscripcion_id) AS inscripcion_key,
    de.estudiante_key,
    dc.curso_key,
    dd.docente_key,
    dp.periodo_key,
    1 AS cantidad_inscripciones
FROM inscripcion i
INNER JOIN estudiante e 
    ON i.estudiante_id = e.estudiante_id
INNER JOIN seccion s 
    ON i.seccion_id = s.seccion_id
INNER JOIN curso c 
    ON s.curso_id = c.curso_id
INNER JOIN docente d 
    ON s.docente_id = d.docente_id
INNER JOIN periodo p 
    ON s.periodo_id = p.periodo_id
INNER JOIN dw_dim_estudiante de 
    ON de.estudiante_id = e.estudiante_id
INNER JOIN dw_dim_curso dc 
    ON dc.curso_id = c.curso_id
INNER JOIN dw_dim_docente dd 
    ON dd.docente_id = d.docente_id
INNER JOIN dw_dim_periodo dp 
    ON dp.periodo_id = p.periodo_id;

COMMIT;

-- ============================================================
-- 4. CARGA DE TABLA DE HECHOS: NOTAS
-- ============================================================

INSERT INTO dw_fact_notas (
    nota_key,
    estudiante_key,
    curso_key,
    docente_key,
    periodo_key,
    promedio_nota,
    nota_maxima,
    nota_minima,
    cantidad_evaluaciones,
    aprobado
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY e.estudiante_id, c.curso_id, d.docente_id, p.periodo_id
    ) AS nota_key,
    de.estudiante_key,
    dc.curso_key,
    dd.docente_key,
    dp.periodo_key,
    ROUND(AVG(n.nota), 2) AS promedio_nota,
    MAX(n.nota) AS nota_maxima,
    MIN(n.nota) AS nota_minima,
    COUNT(n.nota_id) AS cantidad_evaluaciones,
    CASE
        WHEN AVG(n.nota) >= 61 THEN 1
        ELSE 0
    END AS aprobado
FROM nota n
INNER JOIN inscripcion i 
    ON n.inscripcion_id = i.inscripcion_id
INNER JOIN estudiante e 
    ON i.estudiante_id = e.estudiante_id
INNER JOIN seccion s 
    ON i.seccion_id = s.seccion_id
INNER JOIN curso c 
    ON s.curso_id = c.curso_id
INNER JOIN docente d 
    ON s.docente_id = d.docente_id
INNER JOIN periodo p 
    ON s.periodo_id = p.periodo_id
INNER JOIN dw_dim_estudiante de 
    ON de.estudiante_id = e.estudiante_id
INNER JOIN dw_dim_curso dc 
    ON dc.curso_id = c.curso_id
INNER JOIN dw_dim_docente dd 
    ON dd.docente_id = d.docente_id
INNER JOIN dw_dim_periodo dp 
    ON dp.periodo_id = p.periodo_id
GROUP BY
    de.estudiante_key,
    dc.curso_key,
    dd.docente_key,
    dp.periodo_key,
    e.estudiante_id,
    c.curso_id,
    d.docente_id,
    p.periodo_id;

COMMIT;

-- ============================================================
-- 5. VALIDACIÓN DE CARGA
-- ============================================================

SELECT 'DW_DIM_ESTUDIANTE' AS tabla, COUNT(*) AS registros FROM dw_dim_estudiante
UNION ALL
SELECT 'DW_DIM_CURSO', COUNT(*) FROM dw_dim_curso
UNION ALL
SELECT 'DW_DIM_DOCENTE', COUNT(*) FROM dw_dim_docente
UNION ALL
SELECT 'DW_DIM_PERIODO', COUNT(*) FROM dw_dim_periodo
UNION ALL
SELECT 'DW_FACT_INSCRIPCIONES', COUNT(*) FROM dw_fact_inscripciones
UNION ALL
SELECT 'DW_FACT_NOTAS', COUNT(*) FROM dw_fact_notas;