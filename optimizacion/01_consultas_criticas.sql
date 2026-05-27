-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 01_consultas_criticas.sql
-- Descripción: Consultas críticas para medir rendimiento
-- Responsable: Julian
-- Tarea: T-033
-- Ejecutar como: acme_school
-- ============================================================

ALTER SESSION SET CURRENT_SCHEMA = acme_school;

SET TIMING ON;

-- ============================================================
-- CONSULTA 1: INSCRIPCIONES POR PERÍODO
-- Objetivo: Medir cantidad de inscripciones agrupadas por período.
-- Tablas involucradas: periodo, seccion, inscripcion
-- ============================================================

SELECT
    p.periodo_id,
    p.nombre AS periodo,
    COUNT(i.inscripcion_id) AS total_inscripciones,
    COUNT(DISTINCT i.estudiante_id) AS total_estudiantes,
    COUNT(DISTINCT s.curso_id) AS total_cursos
FROM periodo p
INNER JOIN seccion s
    ON p.periodo_id = s.periodo_id
INNER JOIN inscripcion i
    ON s.seccion_id = i.seccion_id
GROUP BY
    p.periodo_id,
    p.nombre
ORDER BY
    p.periodo_id;


-- ============================================================
-- CONSULTA 2: NOTAS PROMEDIO POR CURSO
-- Objetivo: Calcular promedio, nota máxima y nota mínima por curso.
-- Tablas involucradas: curso, seccion, inscripcion, nota
-- ============================================================

SELECT
    c.curso_id,
    c.codigo AS codigo_curso,
    c.nombre AS curso,
    COUNT(n.nota_id) AS total_notas,
    ROUND(AVG(n.valor), 2) AS promedio_nota,
    MAX(n.valor) AS nota_maxima,
    MIN(n.valor) AS nota_minima
FROM curso c
INNER JOIN seccion s
    ON c.curso_id = s.curso_id
INNER JOIN inscripcion i
    ON s.seccion_id = i.seccion_id
INNER JOIN nota n
    ON i.inscripcion_id = n.inscripcion_id
GROUP BY
    c.curso_id,
    c.codigo,
    c.nombre
ORDER BY
    promedio_nota DESC;


-- ============================================================
-- CONSULTA 3: ESTUDIANTES POR SECCIÓN CON PROMEDIO
-- Objetivo: Obtener estudiantes inscritos en secciones y su promedio.
-- Tablas involucradas: estudiante, inscripcion, seccion, curso, nota
-- ============================================================

SELECT
    e.estudiante_id,
    e.codigo AS codigo_estudiante,
    e.nombre || ' ' || e.apellido AS estudiante,
    s.seccion_id,
    c.nombre AS curso,
    ROUND(AVG(n.valor), 2) AS promedio_estudiante
FROM estudiante e
INNER JOIN inscripcion i
    ON e.estudiante_id = i.estudiante_id
INNER JOIN seccion s
    ON i.seccion_id = s.seccion_id
INNER JOIN curso c
    ON s.curso_id = c.curso_id
LEFT JOIN nota n
    ON i.inscripcion_id = n.inscripcion_id
GROUP BY
    e.estudiante_id,
    e.codigo,
    e.nombre,
    e.apellido,
    s.seccion_id,
    c.nombre
ORDER BY
    c.nombre,
    promedio_estudiante DESC;


-- ============================================================
-- CONSULTA 4: KPI OPERACIONAL - TASA DE APROBACIÓN POR CURSO
-- Objetivo: Calcular porcentaje de aprobación por curso.
-- Criterio: aprobado si el valor de la nota es mayor o igual a 61.
-- ============================================================

SELECT
    c.curso_id,
    c.nombre AS curso,
    COUNT(n.nota_id) AS total_evaluaciones,
    SUM(CASE WHEN n.valor >= 61 THEN 1 ELSE 0 END) AS total_aprobados,
    SUM(CASE WHEN n.valor < 61 THEN 1 ELSE 0 END) AS total_reprobados,
    ROUND(
        (SUM(CASE WHEN n.valor >= 61 THEN 1 ELSE 0 END) / COUNT(n.nota_id)) * 100,
        2
    ) AS tasa_aprobacion
FROM curso c
INNER JOIN seccion s
    ON c.curso_id = s.curso_id
INNER JOIN inscripcion i
    ON s.seccion_id = i.seccion_id
INNER JOIN nota n
    ON i.inscripcion_id = n.inscripcion_id
GROUP BY
    c.curso_id,
    c.nombre
ORDER BY
    tasa_aprobacion DESC;


-- ============================================================
-- CONSULTA 5: CARGA DOCENTE POR PERÍODO
-- Objetivo: Medir cuántas secciones e inscripciones atiende cada docente.
-- Tablas involucradas: docente, seccion, periodo, inscripcion
-- ============================================================

SELECT
    d.docente_id,
    d.nombre || ' ' || d.apellido AS docente,
    p.nombre AS periodo,
    COUNT(DISTINCT s.seccion_id) AS total_secciones,
    COUNT(i.inscripcion_id) AS total_inscripciones
FROM docente d
INNER JOIN seccion s
    ON d.docente_id = s.docente_id
INNER JOIN periodo p
    ON s.periodo_id = p.periodo_id
LEFT JOIN inscripcion i
    ON s.seccion_id = i.seccion_id
GROUP BY
    d.docente_id,
    d.nombre,
    d.apellido,
    p.nombre
ORDER BY
    total_inscripciones DESC;


-- ============================================================
-- CONSULTA 6: TOP ESTUDIANTES POR PROMEDIO GENERAL
-- Objetivo: Identificar estudiantes con mejor promedio.
-- Tablas involucradas: estudiante, inscripcion, nota
-- ============================================================

SELECT
    e.estudiante_id,
    e.codigo,
    e.nombre || ' ' || e.apellido AS estudiante,
    COUNT(n.nota_id) AS total_notas,
    ROUND(AVG(n.valor), 2) AS promedio_general
FROM estudiante e
INNER JOIN inscripcion i
    ON e.estudiante_id = i.estudiante_id
INNER JOIN nota n
    ON i.inscripcion_id = n.inscripcion_id
GROUP BY
    e.estudiante_id,
    e.codigo,
    e.nombre,
    e.apellido
ORDER BY
    promedio_general DESC;

SET TIMING OFF;