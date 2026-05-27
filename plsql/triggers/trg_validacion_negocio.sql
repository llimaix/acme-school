-- ACME SCHOOL - Trigger: trg_validacion_negocio
-- Descripción: Validación de reglas de negocio
-- Responsable: Emmanuel, Tarea: T-022

-- Validación en NOTA: valor entre 0 y 100
CREATE OR REPLACE TRIGGER trg_validacion_nota
BEFORE INSERT OR UPDATE ON nota
FOR EACH ROW
BEGIN
    IF :NEW.valor < 0 OR :NEW.valor > 100 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nota fuera de rango permitido (0-100)');
    END IF;
END trg_validacion_nota;
/

-- Validación en INSCRIPCION: período debe estar activo
CREATE OR REPLACE TRIGGER trg_validacion_inscripcion
BEFORE INSERT ON inscripcion
FOR EACH ROW
DECLARE
    v_periodo_estado VARCHAR2(20);
BEGIN
    SELECT p.estado INTO v_periodo_estado
    FROM periodo p
    INNER JOIN seccion s ON p.periodo_id = s.periodo_id
    WHERE s.seccion_id = :NEW.seccion_id;
    
    IF v_periodo_estado != 'ACTIVO' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Período no está activo para inscripción');
    END IF;
EXCEPTION WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20003, 'Sección no encontrada');
END trg_validacion_inscripcion;
/
