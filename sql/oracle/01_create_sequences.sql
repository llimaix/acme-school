-- Secuencias para generación de PKs del modelo operacional.
-- Ejecutar como acme_school.

ALTER SESSION SET CURRENT_SCHEMA = acme_school;

-- NOCACHE evita huecos de IDs ante caídas (relevante para auditoría).
CREATE SEQUENCE seq_estudiante  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_docente     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_curso       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_periodo     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_seccion     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_inscripcion START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_nota        START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_auditoria   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

SELECT sequence_name, last_number, increment_by, cache_size
FROM user_sequences
ORDER BY sequence_name;
