-- Cupo disponible de una sección.

CREATE OR REPLACE FUNCTION fn_cupo_disponible(
    p_seccion_id IN NUMBER
) RETURN NUMBER IS
    v_cupo NUMBER;
BEGIN
    SELECT cupo_disponible
    INTO v_cupo
    FROM seccion
    WHERE seccion_id = p_seccion_id;

    RETURN v_cupo;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;
    WHEN OTHERS THEN RETURN NULL;
END fn_cupo_disponible;
/
