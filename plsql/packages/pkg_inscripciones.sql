-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Package: pkg_inscripciones
-- Descripción: Operaciones de inscripción de estudiantes
-- Responsable: Emmanuel (con apoyo de Wuili)
-- Tareas: T-011, T-012, T-013
-- ============================================================

-- SPEC
CREATE OR REPLACE PACKAGE pkg_inscripciones AS
    PROCEDURE inscribir_estudiante(
        p_estudiante_id IN NUMBER,
        p_seccion_id    IN NUMBER,
        p_resultado     OUT VARCHAR2
    );
    
    PROCEDURE retirar_estudiante(
        p_inscripcion_id IN NUMBER,
        p_resultado      OUT VARCHAR2
    );
END pkg_inscripciones;
/

-- BODY
CREATE OR REPLACE PACKAGE BODY pkg_inscripciones AS

    PROCEDURE inscribir_estudiante(
        p_estudiante_id IN NUMBER,
        p_seccion_id    IN NUMBER,
        p_resultado     OUT VARCHAR2
    ) IS
        v_cupo_disponible NUMBER;
        v_periodo_estado  VARCHAR2(20);
        v_estudiante_estado VARCHAR2(20);
        v_ya_inscrito     NUMBER;
        v_inscripcion_id  NUMBER;
    BEGIN
        p_resultado := 'PENDIENTE';
        
        -- Validar que el estudiante exista y esté ACTIVO
        SELECT estado INTO v_estudiante_estado
        FROM estudiante
        WHERE estudiante_id = p_estudiante_id;
        
        IF v_estudiante_estado != 'ACTIVO' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Estudiante no está activo');
        END IF;
        
        -- Validar que el período esté ACTIVO
        SELECT p.estado INTO v_periodo_estado
        FROM periodo p
        INNER JOIN seccion s ON p.periodo_id = s.periodo_id
        WHERE s.seccion_id = p_seccion_id;
        
        IF v_periodo_estado != 'ACTIVO' THEN
            RAISE_APPLICATION_ERROR(-20002, 'Período no está activo');
        END IF;
        
        -- Validar cupo disponible
        SELECT cupo_disponible INTO v_cupo_disponible
        FROM seccion
        WHERE seccion_id = p_seccion_id;
        
        IF v_cupo_disponible <= 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'No hay cupo disponible');
        END IF;
        
        -- Validar que no esté inscrito previamente
        SELECT COUNT(*) INTO v_ya_inscrito
        FROM inscripcion
        WHERE estudiante_id = p_estudiante_id
        AND seccion_id = p_seccion_id
        AND estado = 'INSCRITO';
        
        IF v_ya_inscrito > 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Estudiante ya está inscrito en esta sección');
        END IF;
        
        -- INSERCIONES EXITOSAS - Ejecutar transacción
        -- 1. Insertar inscripción
        INSERT INTO inscripcion (estudiante_id, seccion_id, estado)
        VALUES (p_estudiante_id, p_seccion_id, 'INSCRITO')
        RETURNING inscripcion_id INTO v_inscripcion_id;
        
        -- 2. Actualizar cupo disponible
        UPDATE seccion
        SET cupo_disponible = cupo_disponible - 1
        WHERE seccion_id = p_seccion_id;
        
        -- 3. COMMIT
        COMMIT;
        p_resultado := 'ÉXITO: Inscripción realizada. ID: ' || v_inscripcion_id;
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 'ERROR: ' || SQLERRM;
    END inscribir_estudiante;
    
    PROCEDURE retirar_estudiante(
        p_inscripcion_id IN NUMBER,
        p_resultado      OUT VARCHAR2
    ) IS
        v_seccion_id NUMBER;
        v_estado_actual VARCHAR2(20);
    BEGIN
        p_resultado := 'PENDIENTE';
        
        -- Obtener datos de la inscripción
        SELECT seccion_id, estado
        INTO v_seccion_id, v_estado_actual
        FROM inscripcion
        WHERE inscripcion_id = p_inscripcion_id;
        
        -- Validar que esté en estado INSCRITO
        IF v_estado_actual != 'INSCRITO' THEN
            RAISE_APPLICATION_ERROR(-20005, 'La inscripción no está en estado INSCRITO');
        END IF;
        
        -- 1. Actualizar estado a RETIRADO
        UPDATE inscripcion
        SET estado = 'RETIRADO'
        WHERE inscripcion_id = p_inscripcion_id;
        
        -- 2. Devolver cupo
        UPDATE seccion
        SET cupo_disponible = cupo_disponible + 1
        WHERE seccion_id = v_seccion_id;
        
        -- 3. COMMIT
        COMMIT;
        p_resultado := 'ÉXITO: Estudiante retirado. Cupo devuelto.';
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            ROLLBACK;
            p_resultado := 'ERROR: Inscripción no encontrada';
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 'ERROR: ' || SQLERRM;
    END retirar_estudiante;

END pkg_inscripciones;
/
