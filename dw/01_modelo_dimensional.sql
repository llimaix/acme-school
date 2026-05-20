-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 01_modelo_dimensional.sql
-- Descripción: DDL del modelo estrella (Data Warehouse)
-- Responsable: Julian
-- Tareas: T-039, T-040
-- ============================================================

-- Modelo Estrella:
--   Dimensiones: dim_estudiante, dim_curso, dim_docente, dim_periodo
--   Hechos: fact_inscripciones, fact_notas
--
-- Puede estar en schema separado (DW_ACME) o con prefijo DW_

-- TODO: Implementar después de T-006

/*
-- DIMENSIONES
CREATE TABLE dw_dim_estudiante (
    estudiante_key  NUMBER PRIMARY KEY,
    estudiante_id   NUMBER NOT NULL,  -- NK del operacional
    codigo          VARCHAR2(20),
    nombre_completo VARCHAR2(200),
    estado          VARCHAR2(20),
    fecha_carga     TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dw_dim_curso (
    curso_key       NUMBER PRIMARY KEY,
    curso_id        NUMBER NOT NULL,
    codigo          VARCHAR2(20),
    nombre          VARCHAR2(150),
    creditos        NUMBER(2),
    fecha_carga     TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dw_dim_docente (
    docente_key     NUMBER PRIMARY KEY,
    docente_id      NUMBER NOT NULL,
    codigo          VARCHAR2(20),
    nombre_completo VARCHAR2(200),
    especialidad    VARCHAR2(100),
    fecha_carga     TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE dw_dim_periodo (
    periodo_key     NUMBER PRIMARY KEY,
    periodo_id      NUMBER NOT NULL,
    codigo          VARCHAR2(20),
    nombre          VARCHAR2(100),
    anio            NUMBER(4),
    semestre        NUMBER(1),
    fecha_carga     TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- HECHOS
CREATE TABLE dw_fact_inscripciones (
    inscripcion_key NUMBER PRIMARY KEY,
    estudiante_key  NUMBER REFERENCES dw_dim_estudiante(estudiante_key),
    curso_key       NUMBER REFERENCES dw_dim_curso(curso_key),
    docente_key     NUMBER REFERENCES dw_dim_docente(docente_key),
    periodo_key     NUMBER REFERENCES dw_dim_periodo(periodo_key),
    cantidad_inscripciones NUMBER DEFAULT 1,
    estado_inscripcion VARCHAR2(20),
    fecha_inscripcion DATE
);

CREATE TABLE dw_fact_notas (
    nota_key        NUMBER PRIMARY KEY,
    estudiante_key  NUMBER REFERENCES dw_dim_estudiante(estudiante_key),
    curso_key       NUMBER REFERENCES dw_dim_curso(curso_key),
    docente_key     NUMBER REFERENCES dw_dim_docente(docente_key),
    periodo_key     NUMBER REFERENCES dw_dim_periodo(periodo_key),
    promedio_nota   NUMBER(5,2),
    nota_maxima     NUMBER(5,2),
    nota_minima     NUMBER(5,2),
    cantidad_evaluaciones NUMBER,
    aprobado        NUMBER(1) -- 1=Sí, 0=No
);
*/
