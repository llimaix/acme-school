-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Function: fn_cupo_disponible
-- Descripción: Verifica cupo disponible en una sección
-- Responsable: Emmanuel
-- Tarea: T-019
-- ============================================================

CREATE OR REPLACE FUNCTION fn_cupo_disponible(
    p_seccion_id IN NUMBER
) RETURN NUMBER IS
    v_cupo NUMBER;
BEGIN
    -- Obtener cupo disponible de la sección
    SELECT cupo_disponible
    INTO v_cupo
    FROM seccion
    WHERE seccion_id = p_seccion_id;
    
    RETURN v_cupo;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RETURN NULL;
END fn_cupo_disponible;
/
