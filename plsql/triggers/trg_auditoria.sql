-- ACME SCHOOL - Trigger: trg_auditoria
-- Descripción: Auditoría de cambios en inscripciones y notas
-- Responsable: Emmanuel, Tarea: T-021

CREATE OR REPLACE TRIGGER trg_auditoria_inscripcion
AFTER INSERT OR UPDATE OR DELETE ON inscripcion
FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_valor_anterior VARCHAR2(4000);
    v_valor_nuevo VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
        v_valor_nuevo := 'est_id=' || :NEW.estudiante_id || ',est=' || :NEW.estado;
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
        v_valor_anterior := 'est=' || :OLD.estado;
        v_valor_nuevo := 'est=' || :NEW.estado;
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
        v_valor_anterior := 'est=' || :OLD.estado;
    END IF;
    
    INSERT INTO auditoria_academica (usuario, fecha_hora, operacion, tabla_afectada, pk_registro, valor_anterior, valor_nuevo)
    VALUES (USER, SYSTIMESTAMP, v_operacion, 'INSCRIPCION', COALESCE(:NEW.inscripcion_id, :OLD.inscripcion_id), v_valor_anterior, v_valor_nuevo);
EXCEPTION WHEN OTHERS THEN NULL;
END trg_auditoria_inscripcion;
/

CREATE OR REPLACE TRIGGER trg_auditoria_nota
AFTER INSERT OR UPDATE OR DELETE ON nota
FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_valor_anterior VARCHAR2(4000);
    v_valor_nuevo VARCHAR2(4000);
BEGIN
    IF INSERTING THEN
        v_operacion := 'INSERT';
        v_valor_nuevo := 'tipo=' || :NEW.tipo_evaluacion || ',valor=' || :NEW.valor;
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
        v_valor_anterior := 'valor=' || :OLD.valor;
        v_valor_nuevo := 'valor=' || :NEW.valor;
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
        v_valor_anterior := 'valor=' || :OLD.valor;
    END IF;
    
    INSERT INTO auditoria_academica (usuario, fecha_hora, operacion, tabla_afectada, pk_registro, valor_anterior, valor_nuevo)
    VALUES (USER, SYSTIMESTAMP, v_operacion, 'NOTA', COALESCE(:NEW.nota_id, :OLD.nota_id), v_valor_anterior, v_valor_nuevo);
EXCEPTION WHEN OTHERS THEN NULL;
END trg_auditoria_nota;
/
