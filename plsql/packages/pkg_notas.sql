-- Package pkg_notas: registro y actualización de notas con validaciones.

-- SPEC
CREATE OR REPLACE PACKAGE pkg_notas AS
    PROCEDURE registrar_nota(
        p_inscripcion_id IN NUMBER,
        p_tipo_evaluacion IN VARCHAR2,
        p_valor IN NUMBER,
        p_resultado OUT VARCHAR2
    );
    
    PROCEDURE actualizar_nota(
        p_nota_id IN NUMBER,
        p_valor IN NUMBER,
        p_resultado OUT VARCHAR2
    );
    
    FUNCTION obtener_promedio(
        p_estudiante_id IN NUMBER
    ) RETURN NUMBER;
    
END pkg_notas;
/

-- BODY
CREATE OR REPLACE PACKAGE BODY pkg_notas AS

    PROCEDURE registrar_nota(
        p_inscripcion_id IN NUMBER,
        p_tipo_evaluacion IN VARCHAR2,
        p_valor IN NUMBER,
        p_resultado OUT VARCHAR2
    ) IS
        v_estado_inscripcion VARCHAR2(20);
        v_nota_id NUMBER;
    BEGIN
        p_resultado := 'PENDIENTE';
        
        -- Validar que la inscripción exista
        SELECT estado INTO v_estado_inscripcion
        FROM inscripcion
        WHERE inscripcion_id = p_inscripcion_id;
        
        -- Validar que la inscripción esté en estado INSCRITO
        IF v_estado_inscripcion != 'INSCRITO' THEN
            RAISE_APPLICATION_ERROR(-20010, 'La inscripción no está en estado INSCRITO');
        END IF;
        
        -- Validar que el valor esté entre 0 y 100
        IF p_valor < 0 OR p_valor > 100 THEN
            RAISE_APPLICATION_ERROR(-20011, 'La nota debe estar entre 0 y 100');
        END IF;
        
        -- Insertar la nota
        INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor)
        VALUES (p_inscripcion_id, p_tipo_evaluacion, p_valor)
        RETURNING nota_id INTO v_nota_id;
        
        -- COMMIT
        COMMIT;
        p_resultado := 'ÉXITO: Nota registrada. ID: ' || v_nota_id;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            ROLLBACK;
            p_resultado := 'ERROR: Inscripción no encontrada';
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 'ERROR: ' || SQLERRM;
    END registrar_nota;
    
    PROCEDURE actualizar_nota(
        p_nota_id IN NUMBER,
        p_valor IN NUMBER,
        p_resultado OUT VARCHAR2
    ) IS
        v_count NUMBER;
    BEGIN
        p_resultado := 'PENDIENTE';
        
        -- Validar que la nota exista
        SELECT COUNT(*) INTO v_count
        FROM nota WHERE nota_id = p_nota_id;
        
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20012, 'Nota no encontrada');
        END IF;
        
        -- Validar que el valor esté entre 0 y 100
        IF p_valor < 0 OR p_valor > 100 THEN
            RAISE_APPLICATION_ERROR(-20011, 'La nota debe estar entre 0 y 100');
        END IF;
        
        -- Actualizar la nota
        UPDATE nota
        SET valor = p_valor
        WHERE nota_id = p_nota_id;
        
        -- COMMIT
        COMMIT;
        p_resultado := 'ÉXITO: Nota actualizada';
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 'ERROR: ' || SQLERRM;
    END actualizar_nota;
    
    FUNCTION obtener_promedio(
        p_estudiante_id IN NUMBER
    ) RETURN NUMBER IS
        v_promedio NUMBER;
    BEGIN
        SELECT AVG(n.valor) INTO v_promedio
        FROM nota n
        JOIN inscripcion i ON n.inscripcion_id = i.inscripcion_id
        WHERE i.estudiante_id = p_estudiante_id;
        
        RETURN ROUND(v_promedio, 2);
        
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END obtener_promedio;

END pkg_notas;
/
