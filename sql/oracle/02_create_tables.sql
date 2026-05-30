-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 02_create_tables.sql
-- Descripción: DDL completo del modelo operacional
-- Responsable: Wuili
-- Tareas: T-006, T-008
-- Ejecutar como: acme_school
-- ============================================================
-- Entidades: Estudiante, Docente, Curso, Período, Sección,
--            Inscripción, Nota, Auditoría Académica
-- ============================================================

ALTER SESSION SET CURRENT_SCHEMA = acme_school;

-- ==================== ESTUDIANTE ====================
CREATE TABLE estudiante (
    estudiante_id    NUMBER DEFAULT seq_estudiante.NEXTVAL,
    codigo           VARCHAR2(20)   NOT NULL,
    nombre           VARCHAR2(100)  NOT NULL,
    apellido         VARCHAR2(100)  NOT NULL,
    email            VARCHAR2(150),
    fecha_nacimiento DATE,
    estado           VARCHAR2(20)   DEFAULT 'ACTIVO' NOT NULL,
    fecha_registro   TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_estudiante PRIMARY KEY (estudiante_id),
    CONSTRAINT uk_estudiante_codigo UNIQUE (codigo),
    CONSTRAINT uk_estudiante_email UNIQUE (email),
    CONSTRAINT chk_estudiante_estado CHECK (estado IN ('ACTIVO','INACTIVO','GRADUADO'))
);

COMMENT ON TABLE estudiante IS 'Estudiantes del sistema académico';
COMMENT ON COLUMN estudiante.codigo IS 'Código único de matrícula (ej: EST-001)';
COMMENT ON COLUMN estudiante.estado IS 'ACTIVO, INACTIVO o GRADUADO';

-- ==================== DOCENTE ====================
CREATE TABLE docente (
    docente_id     NUMBER DEFAULT seq_docente.NEXTVAL,
    codigo         VARCHAR2(20)  NOT NULL,
    nombre         VARCHAR2(100) NOT NULL,
    apellido       VARCHAR2(100) NOT NULL,
    email          VARCHAR2(150),
    especialidad   VARCHAR2(100),
    estado         VARCHAR2(20)  DEFAULT 'ACTIVO' NOT NULL,
    fecha_registro TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT pk_docente PRIMARY KEY (docente_id),
    CONSTRAINT uk_docente_codigo UNIQUE (codigo),
    CONSTRAINT uk_docente_email UNIQUE (email),
    CONSTRAINT chk_docente_estado CHECK (estado IN ('ACTIVO','INACTIVO'))
);

COMMENT ON TABLE docente IS 'Docentes que imparten secciones';

-- ==================== CURSO ====================
CREATE TABLE curso (
    curso_id    NUMBER DEFAULT seq_curso.NEXTVAL,
    codigo      VARCHAR2(20)  NOT NULL,
    nombre      VARCHAR2(150) NOT NULL,
    creditos    NUMBER(2)     NOT NULL,
    descripcion VARCHAR2(500),
    estado      VARCHAR2(20)  DEFAULT 'ACTIVO' NOT NULL,
    CONSTRAINT pk_curso PRIMARY KEY (curso_id),
    CONSTRAINT uk_curso_codigo UNIQUE (codigo),
    CONSTRAINT chk_curso_creditos CHECK (creditos BETWEEN 1 AND 10),
    CONSTRAINT chk_curso_estado CHECK (estado IN ('ACTIVO','INACTIVO'))
);

COMMENT ON TABLE curso IS 'Catálogo de cursos académicos';

-- ==================== PERIODO ====================
CREATE TABLE periodo (
    periodo_id   NUMBER DEFAULT seq_periodo.NEXTVAL,
    codigo       VARCHAR2(20)  NOT NULL,
    nombre       VARCHAR2(100) NOT NULL,
    fecha_inicio DATE          NOT NULL,
    fecha_fin    DATE          NOT NULL,
    estado       VARCHAR2(20)  DEFAULT 'PLANIFICADO' NOT NULL,
    CONSTRAINT pk_periodo PRIMARY KEY (periodo_id),
    CONSTRAINT uk_periodo_codigo UNIQUE (codigo),
    CONSTRAINT chk_periodo_fechas CHECK (fecha_fin > fecha_inicio),
    CONSTRAINT chk_periodo_estado CHECK (estado IN ('ACTIVO','CERRADO','PLANIFICADO'))
);

COMMENT ON TABLE periodo IS 'Períodos académicos (semestres/ciclos)';

-- ==================== SECCION ====================
CREATE TABLE seccion (
    seccion_id      NUMBER DEFAULT seq_seccion.NEXTVAL,
    curso_id        NUMBER       NOT NULL,
    docente_id      NUMBER       NOT NULL,
    periodo_id      NUMBER       NOT NULL,
    codigo_seccion  VARCHAR2(10) NOT NULL,
    cupo_maximo     NUMBER(3)    NOT NULL,
    cupo_disponible NUMBER(3)    NOT NULL,
    horario         VARCHAR2(100),
    aula            VARCHAR2(50),
    estado          VARCHAR2(20) DEFAULT 'ABIERTA' NOT NULL,
    CONSTRAINT pk_seccion PRIMARY KEY (seccion_id),
    CONSTRAINT fk_seccion_curso   FOREIGN KEY (curso_id)   REFERENCES curso(curso_id),
    CONSTRAINT fk_seccion_docente FOREIGN KEY (docente_id) REFERENCES docente(docente_id),
    CONSTRAINT fk_seccion_periodo FOREIGN KEY (periodo_id) REFERENCES periodo(periodo_id),
    CONSTRAINT uk_seccion UNIQUE (curso_id, periodo_id, codigo_seccion),
    CONSTRAINT chk_seccion_cupo_max CHECK (cupo_maximo > 0),
    CONSTRAINT chk_seccion_cupo_disp CHECK (cupo_disponible >= 0),
    CONSTRAINT chk_seccion_cupo_lim CHECK (cupo_disponible <= cupo_maximo),
    CONSTRAINT chk_seccion_estado CHECK (estado IN ('ABIERTA','CERRADA','CANCELADA'))
);

COMMENT ON TABLE seccion IS 'Secciones de cursos en un período con docente asignado';
COMMENT ON COLUMN seccion.cupo_disponible IS 'Cupos restantes; se decrementa al inscribir';

-- ==================== INSCRIPCION ====================
CREATE TABLE inscripcion (
    inscripcion_id    NUMBER DEFAULT seq_inscripcion.NEXTVAL,
    estudiante_id     NUMBER       NOT NULL,
    seccion_id        NUMBER       NOT NULL,
    fecha_inscripcion TIMESTAMP    DEFAULT SYSTIMESTAMP NOT NULL,
    estado            VARCHAR2(20) DEFAULT 'INSCRITO' NOT NULL,
    CONSTRAINT pk_inscripcion PRIMARY KEY (inscripcion_id),
    CONSTRAINT fk_inscripcion_estudiante FOREIGN KEY (estudiante_id) REFERENCES estudiante(estudiante_id),
    CONSTRAINT fk_inscripcion_seccion    FOREIGN KEY (seccion_id)    REFERENCES seccion(seccion_id),
    CONSTRAINT uk_inscripcion UNIQUE (estudiante_id, seccion_id),
    CONSTRAINT chk_inscripcion_estado CHECK (estado IN ('INSCRITO','RETIRADO','COMPLETADO'))
);

COMMENT ON TABLE inscripcion IS 'Inscripción de un estudiante en una sección';
COMMENT ON COLUMN inscripcion.estado IS 'INSCRITO, RETIRADO o COMPLETADO';

-- ==================== NOTA ====================
CREATE TABLE nota (
    nota_id         NUMBER DEFAULT seq_nota.NEXTVAL,
    inscripcion_id  NUMBER        NOT NULL,
    tipo_evaluacion VARCHAR2(50)  NOT NULL,
    valor           NUMBER(5,2)   NOT NULL,
    fecha_registro  TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL,
    observacion     VARCHAR2(200),
    CONSTRAINT pk_nota PRIMARY KEY (nota_id),
    CONSTRAINT fk_nota_inscripcion FOREIGN KEY (inscripcion_id) REFERENCES inscripcion(inscripcion_id),
    CONSTRAINT chk_nota_valor CHECK (valor BETWEEN 0 AND 100)
);

COMMENT ON TABLE nota IS 'Calificaciones de evaluaciones por inscripción';

-- ==================== AUDITORIA ACADEMICA ====================
CREATE TABLE auditoria_academica (
    auditoria_id   NUMBER DEFAULT seq_auditoria.NEXTVAL,
    usuario        VARCHAR2(50)   DEFAULT USER NOT NULL,
    fecha_hora     TIMESTAMP      DEFAULT SYSTIMESTAMP NOT NULL,
    operacion      VARCHAR2(10)   NOT NULL,
    tabla_afectada VARCHAR2(50)   NOT NULL,
    pk_registro    NUMBER,
    valor_anterior VARCHAR2(4000),
    valor_nuevo    VARCHAR2(4000),
    CONSTRAINT pk_auditoria PRIMARY KEY (auditoria_id),
    CONSTRAINT chk_auditoria_operacion CHECK (operacion IN ('INSERT','UPDATE','DELETE'))
);

COMMENT ON TABLE auditoria_academica IS 'Bitácora de cambios en tablas críticas';

-- ==================== ÍNDICES ADICIONALES (FK no indexadas) ====================
-- Los índices estratégicos de optimización los maneja Julian (T-036)
-- Aquí solo agrego los necesarios para FKs (Oracle no los crea automáticamente)

CREATE INDEX idx_seccion_curso   ON seccion(curso_id);
CREATE INDEX idx_seccion_docente ON seccion(docente_id);
CREATE INDEX idx_seccion_periodo ON seccion(periodo_id);

-- ==================== VERIFICACIÓN ====================
SELECT table_name FROM user_tables ORDER BY table_name;
SELECT constraint_name, constraint_type, table_name
FROM user_constraints
WHERE table_name IN ('ESTUDIANTE','DOCENTE','CURSO','PERIODO','SECCION','INSCRIPCION','NOTA','AUDITORIA_ACADEMICA')
ORDER BY table_name, constraint_type;
