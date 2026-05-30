-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: 06_constraints_validation.sql
-- Descripción: Pruebas de integridad referencial y constraints
-- Responsable: Luis (completado por Luis ante ausencia de Emmanuel)
-- Tarea: T-010
-- Ejecutar como: acme_school
-- Prerrequisito: Tablas y datos cargados (01-05)
-- ============================================================

SET SERVEROUTPUT ON;

PROMPT === PRUEBAS DE INTEGRIDAD REFERENCIAL ===
PROMPT Cada prueba debe FALLAR con un error ORA controlado.
PROMPT

-- ============================================================
-- PRUEBA 1: FK inválida (estudiante inexistente)
-- Error esperado: ORA-02291 integrity constraint violated - parent key not found
-- ============================================================
PROMPT [PRUEBA 1] INSERT con FK invalida (estudiante_id=9999)
BEGIN
    INSERT INTO inscripcion (estudiante_id, seccion_id, estado)
    VALUES (9999, 11, 'INSCRITO');
    DBMS_OUTPUT.PUT_LINE('ERROR: No debio permitir el INSERT');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK - Error controlado: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ============================================================
-- PRUEBA 2: UNIQUE constraint violado (inscripción duplicada)
-- Error esperado: ORA-00001 unique constraint violated
-- ============================================================
PROMPT [PRUEBA 2] INSERT duplicado (EST-001 ya inscrito en seccion 15)
BEGIN
    INSERT INTO inscripcion (estudiante_id, seccion_id, estado)
    VALUES (1, 15, 'INSCRITO');
    DBMS_OUTPUT.PUT_LINE('ERROR: No debio permitir el INSERT');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK - Error controlado: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ============================================================
-- PRUEBA 3: CHECK constraint violado (nota > 100)
-- Error esperado: ORA-02290 check constraint violated
-- ============================================================
PROMPT [PRUEBA 3] INSERT con nota=150 (fuera de rango 0-100)
BEGIN
    INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor)
    VALUES (1, 'Extra', 150);
    DBMS_OUTPUT.PUT_LINE('ERROR: No debio permitir el INSERT');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK - Error controlado: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ============================================================
-- PRUEBA 4: CHECK constraint violado (nota < 0)
-- Error esperado: ORA-02290 check constraint violated
-- ============================================================
PROMPT [PRUEBA 4] INSERT con nota=-5 (negativa)
BEGIN
    INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor)
    VALUES (1, 'Extra', -5);
    DBMS_OUTPUT.PUT_LINE('ERROR: No debio permitir el INSERT');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK - Error controlado: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ============================================================
-- PRUEBA 5: CHECK constraint violado (estado inválido)
-- Error esperado: ORA-02290 check constraint violated
-- ============================================================
PROMPT [PRUEBA 5] INSERT con estado invalido en estudiante
BEGIN
    INSERT INTO estudiante (codigo, nombre, apellido, estado)
    VALUES ('EST-FAIL', 'Test', 'Fail', 'ELIMINADO');
    DBMS_OUTPUT.PUT_LINE('ERROR: No debio permitir el INSERT');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK - Error controlado: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ============================================================
-- PRUEBA 6: DELETE de registro referenciado por FK
-- Error esperado: ORA-02292 integrity constraint violated - child record found
-- ============================================================
PROMPT [PRUEBA 6] DELETE de estudiante con inscripciones activas
BEGIN
    DELETE FROM estudiante WHERE estudiante_id = 1;
    DBMS_OUTPUT.PUT_LINE('ERROR: No debio permitir el DELETE');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK - Error controlado: ' || SQLERRM);
        ROLLBACK;
END;
/

-- ============================================================
-- PRUEBA 7: CHECK constraint en seccion (cupo_disponible < 0)
-- Error esperado: ORA-02290 check constraint violated
-- ============================================================
PROMPT [PRUEBA 7] UPDATE cupo_disponible a -1
BEGIN
    UPDATE seccion SET cupo_disponible = -1 WHERE seccion_id = 11;
    DBMS_OUTPUT.PUT_LINE('ERROR: No debio permitir el UPDATE');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK - Error controlado: ' || SQLERRM);
        ROLLBACK;
END;
/

PROMPT
PROMPT === TODAS LAS PRUEBAS COMPLETADAS ===
PROMPT Si todas muestran "OK - Error controlado", la integridad funciona.
