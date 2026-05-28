-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Function: fn_estado_aprobacion
-- Descripción: Determina si un estudiante aprobó un curso
-- Responsable: Emmanuel
-- Tarea: T-019
-- ============================================================

CREATE OR REPLACE FUNCTION fn_estado_aprobacion(
    p_inscripcion_id IN NUMBER
) RETURN VARCHAR2 IS
    v_promedio NUMBER;
    v_calificacion VARCHAR2(20);
BEGIN
    -- Obtener promedio de notas de la inscripción
    SELECT AVG(valor)
    INTO v_promedio
    FROM nota
    WHERE inscripcion_id = p_inscripcion_id;
    
    -- Determinar si aprobó (>= 61) o reprobó (< 61)
    IF v_promedio IS NULL THEN
        v_calificacion := 'SIN_CALIFICACION';
    ELSIF v_promedio >= 61 THEN
        v_calificacion := 'APROBADO';
    ELSE
        v_calificacion := 'REPROBADO';
    END IF;
    
    RETURN v_calificacion;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'SIN_NOTAS';
    WHEN OTHERS THEN
        RETURN 'ERROR';
END fn_estado_aprobacion;
/
