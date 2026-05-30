-- Triggers de validación de reglas de negocio.

-- Nota dentro del rango 0-100.
CREATE OR REPLACE TRIGGER trg_validacion_nota
BEFORE INSERT OR UPDATE ON nota
FOR EACH ROW
BEGIN
    IF :NEW.valor < 0 OR :NEW.valor > 100 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nota fuera de rango permitido (0-100)');
    END IF;
END trg_validacion_nota;
/

-- Inscripción solo en período activo.
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
