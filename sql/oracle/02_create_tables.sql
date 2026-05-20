-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 02_create_tables.sql
-- Descripción: DDL de tablas del modelo operacional
-- Responsable: Wuili
-- Tareas: T-006, T-008
-- ============================================================

-- Entidades principales:
--   Estudiante, Docente, Curso, Sección, Período, Inscripción, Nota
--
-- Notas técnicas Oracle:
--   - Usar NUMBER, VARCHAR2, DATE/TIMESTAMP
--   - Evitar sintaxis MySQL
--   - Incluir PK, FK, CHECK y UNIQUE constraints

-- TODO: Implementar según diagrama ER aprobado (T-006)

/*
CREATE TABLE estudiante (
    estudiante_id   NUMBER PRIMARY KEY,
    codigo          VARCHAR2(20) NOT NULL UNIQUE,
    nombre          VARCHAR2(100) NOT NULL,
    apellido        VARCHAR2(100) NOT NULL,
    email           VARCHAR2(150) UNIQUE,
    fecha_nacimiento DATE,
    estado          VARCHAR2(20) DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO','INACTIVO','GRADUADO')),
    fecha_registro  TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE docente (
    docente_id      NUMBER PRIMARY KEY,
    codigo          VARCHAR2(20) NOT NULL UNIQUE,
    nombre          VARCHAR2(100) NOT NULL,
    apellido        VARCHAR2(100) NOT NULL,
    email           VARCHAR2(150) UNIQUE,
    especialidad    VARCHAR2(100),
    estado          VARCHAR2(20) DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO','INACTIVO')),
    fecha_registro  TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE TABLE curso (
    curso_id        NUMBER PRIMARY KEY,
    codigo          VARCHAR2(20) NOT NULL UNIQUE,
    nombre          VARCHAR2(150) NOT NULL,
    creditos        NUMBER(2) NOT NULL CHECK (creditos > 0),
    descripcion     VARCHAR2(500),
    estado          VARCHAR2(20) DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO','INACTIVO'))
);

CREATE TABLE periodo (
    periodo_id      NUMBER PRIMARY KEY,
    codigo          VARCHAR2(20) NOT NULL UNIQUE,
    nombre          VARCHAR2(100) NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE NOT NULL,
    estado          VARCHAR2(20) DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO','CERRADO','PLANIFICADO')),
    CONSTRAINT chk_fechas_periodo CHECK (fecha_fin > fecha_inicio)
);

CREATE TABLE seccion (
    seccion_id      NUMBER PRIMARY KEY,
    curso_id        NUMBER NOT NULL REFERENCES curso(curso_id),
    docente_id      NUMBER NOT NULL REFERENCES docente(docente_id),
    periodo_id      NUMBER NOT NULL REFERENCES periodo(periodo_id),
    codigo_seccion  VARCHAR2(10) NOT NULL,
    cupo_maximo     NUMBER(3) NOT NULL CHECK (cupo_maximo > 0),
    cupo_disponible NUMBER(3) NOT NULL CHECK (cupo_disponible >= 0),
    horario         VARCHAR2(100),
    aula            VARCHAR2(50),
    estado          VARCHAR2(20) DEFAULT 'ABIERTA' CHECK (estado IN ('ABIERTA','CERRADA','CANCELADA')),
    CONSTRAINT uk_seccion UNIQUE (curso_id, periodo_id, codigo_seccion)
);

CREATE TABLE inscripcion (
    inscripcion_id  NUMBER PRIMARY KEY,
    estudiante_id   NUMBER NOT NULL REFERENCES estudiante(estudiante_id),
    seccion_id      NUMBER NOT NULL REFERENCES seccion(seccion_id),
    fecha_inscripcion TIMESTAMP DEFAULT SYSTIMESTAMP,
    estado          VARCHAR2(20) DEFAULT 'INSCRITO' CHECK (estado IN ('INSCRITO','RETIRADO','COMPLETADO')),
    CONSTRAINT uk_inscripcion UNIQUE (estudiante_id, seccion_id)
);

CREATE TABLE nota (
    nota_id         NUMBER PRIMARY KEY,
    inscripcion_id  NUMBER NOT NULL REFERENCES inscripcion(inscripcion_id),
    tipo_evaluacion VARCHAR2(50) NOT NULL,
    valor           NUMBER(5,2) NOT NULL CHECK (valor BETWEEN 0 AND 100),
    fecha_registro  TIMESTAMP DEFAULT SYSTIMESTAMP,
    observacion     VARCHAR2(200)
);
*/
