-- ============================================================
-- SPRINT 1 - CONSULTAS PARA CAPTURA DE EVIDENCIA
-- Ejecutar cada bloque en SQL Developer como acme_school
-- Capturar pantalla después de cada ejecución
-- ============================================================

-- ============================================================
-- T-008a: Secuencias creadas
-- ============================================================
SELECT sequence_name, last_number, increment_by, cache_size
FROM user_sequences
WHERE sequence_name LIKE 'SEQ_%'
ORDER BY sequence_name;

-- ============================================================
-- T-008b: Tablas creadas con constraints
-- ============================================================
SELECT table_name FROM user_tables ORDER BY table_name;

SELECT constraint_name, constraint_type, table_name, status
FROM user_constraints
WHERE table_name IN ('ESTUDIANTE','DOCENTE','CURSO','PERIODO','SECCION','INSCRIPCION','NOTA','AUDITORIA_ACADEMICA')
ORDER BY table_name, constraint_type;

-- ============================================================
-- T-009: Conteo de datos por tabla
-- ============================================================
SELECT 'estudiantes' AS tabla, COUNT(*) AS total FROM estudiante UNION ALL
SELECT 'docentes',    COUNT(*) FROM docente    UNION ALL
SELECT 'cursos',      COUNT(*) FROM curso      UNION ALL
SELECT 'periodos',    COUNT(*) FROM periodo    UNION ALL
SELECT 'secciones',   COUNT(*) FROM seccion    UNION ALL
SELECT 'inscripciones', COUNT(*) FROM inscripcion UNION ALL
SELECT 'notas',       COUNT(*) FROM nota
ORDER BY tabla;

-- ============================================================
-- T-010: Pruebas de integridad (errores ORA controlados)
-- ============================================================
SET SERVEROUTPUT ON;

BEGIN
    INSERT INTO inscripcion (estudiante_id, seccion_id, estado) VALUES (9999, 11, 'INSCRITO');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[FK] ' || SQLERRM);
END;
/
BEGIN
    INSERT INTO inscripcion (estudiante_id, seccion_id, estado) VALUES (1, 15, 'INSCRITO');
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[UNIQUE] ' || SQLERRM);
END;
/
BEGIN
    INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (1, 'X', 150);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[CHECK] ' || SQLERRM);
END;
/
BEGIN
    DELETE FROM estudiante WHERE estudiante_id = 1;
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[FK-DEL] ' || SQLERRM);
END;
/

-- ============================================================
-- T-011: pkg_inscripciones compilado + prueba
-- ============================================================
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name = 'PKG_INSCRIPCIONES';

DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    pkg_inscripciones.inscribir_estudiante(20, 12, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/

-- ============================================================
-- T-018: pkg_notas compilado + prueba
-- ============================================================
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name = 'PKG_NOTAS';

DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    pkg_notas.registrar_nota(68, 'Parcial 1', 75.00, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/

-- ============================================================
-- T-019: Funciones PL/SQL
-- ============================================================
SELECT
    fn_promedio_estudiante(1) AS promedio_est_001,
    fn_cupo_disponible(11)   AS cupo_seccion_11,
    fn_estado_aprobacion(1)  AS estado_insc_1
FROM DUAL;

-- ============================================================
-- T-021: Trigger de auditoría (verificar que registra)
-- ============================================================
-- Hacer un UPDATE para disparar el trigger
UPDATE nota SET valor = 80 WHERE nota_id = 1;
COMMIT;

SELECT auditoria_id, usuario, operacion, tabla_afectada, pk_registro,
       valor_anterior, valor_nuevo, fecha_hora
FROM auditoria_academica
ORDER BY auditoria_id DESC
FETCH FIRST 5 ROWS ONLY;

-- ============================================================
-- T-022: Trigger de validación (debe fallar)
-- ============================================================
BEGIN
    INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor) VALUES (1, 'Test', 200);
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('[TRIGGER] ' || SQLERRM);
END;
/

-- ============================================================
-- T-012: COMMIT exitoso (antes y después)
-- ============================================================
-- Estado antes
SELECT s.seccion_id, s.cupo_disponible FROM seccion s WHERE s.seccion_id = 12;

-- Inscribir
DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    pkg_inscripciones.inscribir_estudiante(22, 12, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/

-- Estado después (cupo debe haber bajado)
SELECT s.seccion_id, s.cupo_disponible FROM seccion s WHERE s.seccion_id = 12;

-- ============================================================
-- T-013: ROLLBACK (cupo lleno en sección 18)
-- ============================================================
-- Sección 18 tiene cupo=0
SELECT seccion_id, cupo_disponible FROM seccion WHERE seccion_id = 18;

DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    pkg_inscripciones.inscribir_estudiante(20, 18, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/

-- Cupo sigue en 0 (ROLLBACK funcionó)
SELECT seccion_id, cupo_disponible FROM seccion WHERE seccion_id = 18;

-- ============================================================
-- T-014/T-015: READ COMMITTED y SERIALIZABLE
-- (Requiere 2 sesiones - documentar con capturas manuales)
-- Ver: transacciones/03_read_committed.sql
-- Ver: transacciones/04_serializable.sql
-- ============================================================

-- ============================================================
-- T-016/T-017: Deadlock y solución
-- (Requiere 2 sesiones para T-016)
-- Solución compilada:
-- ============================================================
SELECT object_name, object_type, status
FROM user_objects
WHERE object_name = 'PKG_INSCRIPCION_DOBLE_SECCION';
