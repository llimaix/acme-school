-- ============================================================
-- ACME SCHOOL - Tablas del Modelo Operacional
-- Ejecutar como: acme_school
-- ============================================================

ALTER SESSION SET CURRENT_SCHEMA = acme_school;

-- ==================== ESTUDIANTE ====================
CREATE TABLE estudiante (
    estudiante_id    NUMBER DEFAULT seq_estudiante.NEXTVAL PRIMARY KEY,
    codigo           VARCHAR2(20) NOT NULL UNIQUE,
    nombre           VARCHAR2(100) NOT NULL,
    apellido         VARCHAR2(100) NOT NULL,
    email            VARCHAR2(150) UNIQUE,
    fecha_nacimiento DATE,
    estado           VARCHAR2(20) DEFAULT 'ACTIVO' 
                     CHECK (estado IN ('ACTIVO','INACTIVO','GRADUADO')),
    fecha_registro   TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- ==================== DOCENTE ====================
CREATE TABLE docente (
    docente_id    NUMBER DEFAULT seq_docente.NEXTVAL PRIMARY KEY,
    codigo        VARCHAR2(20) NOT NULL UNIQUE,
    nombre        VARCHAR2(100) NOT NULL,
    apellido      VARCHAR2(100) NOT NULL,
    email         VARCHAR2(150) UNIQUE,
    especialidad  VARCHAR2(100),
    estado        VARCHAR2(20) DEFAULT 'ACTIVO' 
                  CHECK (estado IN ('ACTIVO','INACTIVO')),
    fecha_registro TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- ==================== CURSO ====================
CREATE TABLE curso (
    curso_id    NUMBER DEFAULT seq_curso.NEXTVAL PRIMARY KEY,
    codigo      VARCHAR2(20) NOT NULL UNIQUE,
    nombre      VARCHAR2(150) NOT NULL,
    creditos    NUMBER(2) NOT NULL CHECK (creditos > 0),
    descripcion VARCHAR2(500),
    estado      VARCHAR2(20) DEFAULT 'ACTIVO' 
                CHECK (estado IN ('ACTIVO','INACTIVO'))
);

-- ==================== PERIODO ====================
CREATE TABLE periodo (
    periodo_id   NUMBER DEFAULT seq_periodo.NEXTVAL PRIMARY KEY,
    codigo       VARCHAR2(20) NOT NULL UNIQUE,
    nombre       VARCHAR2(100) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin    DATE NOT NULL,
    estado       VARCHAR2(20) DEFAULT 'PLANIFICADO' 
                 CHECK (estado IN ('ACTIVO','CERRADO','PLANIFICADO')),
    CONSTRAINT chk_fechas_periodo CHECK (fecha_fin > fecha_inicio)
);

-- ==================== SECCION ====================
CREATE TABLE seccion (
    seccion_id      NUMBER DEFAULT seq_seccion.NEXTVAL PRIMARY KEY,
    curso_id        NUMBER NOT NULL REFERENCES curso(curso_id),
    docente_id      NUMBER NOT NULL REFERENCES docente(docente_id),
    periodo_id      NUMBER NOT NULL REFERENCES periodo(periodo_id),
    codigo_seccion  VARCHAR2(10) NOT NULL,
    cupo_maximo     NUMBER(3) NOT NULL CHECK (cupo_maximo > 0),
    cupo_disponible NUMBER(3) NOT NULL CHECK (cupo_disponible >= 0),
    horario         VARCHAR2(100),
    aula            VARCHAR2(50),
    estado          VARCHAR2(20) DEFAULT 'ABIERTA' 
                    CHECK (estado IN ('ABIERTA','CERRADA','CANCELADA')),
    CONSTRAINT uk_seccion UNIQUE (curso_id, periodo_id, codigo_seccion)
);

-- ==================== INSCRIPCION ====================
CREATE TABLE inscripcion (
    inscripcion_id    NUMBER DEFAULT seq_inscripcion.NEXTVAL PRIMARY KEY,
    estudiante_id     NUMBER NOT NULL REFERENCES estudiante(estudiante_id),
    seccion_id        NUMBER NOT NULL REFERENCES seccion(seccion_id),
    fecha_inscripcion TIMESTAMP DEFAULT SYSTIMESTAMP,
    estado            VARCHAR2(20) DEFAULT 'INSCRITO' 
                      CHECK (estado IN ('INSCRITO','RETIRADO','COMPLETADO')),
    CONSTRAINT uk_inscripcion UNIQUE (estudiante_id, seccion_id)
);

-- ==================== NOTA ====================
CREATE TABLE nota (
    nota_id         NUMBER DEFAULT seq_nota.NEXTVAL PRIMARY KEY,
    inscripcion_id  NUMBER NOT NULL REFERENCES inscripcion(inscripcion_id),
    tipo_evaluacion VARCHAR2(50) NOT NULL,
    valor           NUMBER(5,2) NOT NULL CHECK (valor BETWEEN 0 AND 100),
    fecha_registro  TIMESTAMP DEFAULT SYSTIMESTAMP,
    observacion     VARCHAR2(200)
);

-- ==================== AUDITORIA ====================
CREATE TABLE auditoria_academica (
    auditoria_id   NUMBER DEFAULT seq_auditoria.NEXTVAL PRIMARY KEY,
    usuario        VARCHAR2(50) DEFAULT USER,
    fecha_hora     TIMESTAMP DEFAULT SYSTIMESTAMP,
    operacion      VARCHAR2(10) NOT NULL CHECK (operacion IN ('INSERT','UPDATE','DELETE')),
    tabla_afectada VARCHAR2(50) NOT NULL,
    pk_registro    NUMBER,
    valor_anterior VARCHAR2(4000),
    valor_nuevo    VARCHAR2(4000)
);
