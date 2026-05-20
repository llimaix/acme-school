-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Package: pkg_inscripciones
-- Descripción: Operaciones de inscripción de estudiantes
-- Responsable: Emmanuel (con apoyo de Wuili)
-- Tareas: T-011, T-012, T-013
-- ============================================================

-- Operación crítica: inscribir_estudiante
-- Validaciones:
--   1. Período activo
--   2. Cupo disponible > 0
--   3. Estudiante no inscrito previamente en la misma sección
--   4. Estudiante activo
--
-- Comportamiento transaccional:
--   - COMMIT explícito si todo es válido
--   - ROLLBACK si alguna validación falla
--   - Actualización de cupo_disponible

-- SPEC
/*
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
*/

-- BODY
/*
CREATE OR REPLACE PACKAGE BODY pkg_inscripciones AS
    PROCEDURE inscribir_estudiante(
        p_estudiante_id IN NUMBER,
        p_seccion_id    IN NUMBER,
        p_resultado     OUT VARCHAR2
    ) IS
        v_cupo_disponible NUMBER;
        v_periodo_estado  VARCHAR2(20);
        v_ya_inscrito     NUMBER;
    BEGIN
        -- Validar período activo
        -- Validar cupo
        -- Validar no duplicado
        -- INSERT inscripción
        -- UPDATE cupo_disponible
        -- COMMIT
        NULL; -- TODO: Implementar
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 'ERROR: ' || SQLERRM;
    END inscribir_estudiante;
    
    PROCEDURE retirar_estudiante(
        p_inscripcion_id IN NUMBER,
        p_resultado      OUT VARCHAR2
    ) IS
    BEGIN
        NULL; -- TODO: Implementar
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_resultado := 'ERROR: ' || SQLERRM;
    END retirar_estudiante;
END pkg_inscripciones;
/
*/
