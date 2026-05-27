-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Function: fn_promedio_estudiante
-- Descripción: Calcula el promedio de notas de un estudiante
-- Responsable: Emmanuel
-- Tarea: T-019
-- ============================================================

CREATE OR REPLACE FUNCTION fn_promedio_estudiante(
    p_estudiante_id IN NUMBER
) RETURN NUMBER IS
    v_promedio NUMBER;
BEGIN
    -- Calcular promedio de todas las notas del estudiante
    SELECT AVG(n.valor)
    INTO v_promedio
    FROM nota n
    INNER JOIN inscripcion i ON n.inscripcion_id = i.inscripcion_id
    WHERE i.estudiante_id = p_estudiante_id;
    
    RETURN ROUND(v_promedio, 2);
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END fn_promedio_estudiante;
/
