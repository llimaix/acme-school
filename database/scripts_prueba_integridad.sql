-- ACME SCHOOL - Script de Pruebas de Integridad Referencial
-- Responsable: Emmanuel, Tarea: T-010

ALTER SESSION SET CURRENT_SCHEMA = acme_school;

-- Prueba de integridad referencial
BEGIN
  DBMS_OUTPUT.PUT_LINE('Pruebas de integridad iniciadas');
  
  -- Insertar datos de prueba
  INSERT INTO periodo (codigo, nombre, fecha_inicio, fecha_fin, estado)
  VALUES ('2025-TEST', 'Test Period', SYSDATE, SYSDATE + 30, 'ACTIVO');
  
  INSERT INTO docente (codigo, nombre, apellido, estado)
  VALUES ('DOC-TEST', 'Test', 'Docente', 'ACTIVO');
  
  INSERT INTO curso (codigo, nombre, creditos, estado)
  VALUES ('CURSO-TEST', 'Test Course', 3, 'ACTIVO');
  
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('✓ Datos de prueba insertados');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
    ROLLBACK;
END;
/
