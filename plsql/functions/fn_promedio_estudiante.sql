-- Promedio de todas las notas de un estudiante.

CREATE OR REPLACE FUNCTION fn_promedio_estudiante(
    p_estudiante_id IN NUMBER
) RETURN NUMBER IS
    v_promedio NUMBER;
BEGIN
    SELECT AVG(n.valor)
    INTO v_promedio
    FROM nota n
    INNER JOIN inscripcion i ON n.inscripcion_id = i.inscripcion_id
    WHERE i.estudiante_id = p_estudiante_id;

    RETURN ROUND(v_promedio, 2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN NULL;
    WHEN OTHERS THEN RETURN NULL;
END fn_promedio_estudiante;
/
