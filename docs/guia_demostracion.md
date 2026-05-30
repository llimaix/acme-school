# Guía de Demostración — Consultas por Criterio

Consultas listas para ejecutar en SQL Developer y evidenciar cada uno de los
7 componentes del proyecto. Salvo que se indique otro usuario, conéctate como
`acme_school / AcmeSchool2025`.

> Antes de empezar, fija el schema:
> ```sql
> ALTER SESSION SET CURRENT_SCHEMA = acme_school;
> SET SERVEROUTPUT ON;
> ```

---

## 1. Transacciones y Control de Concurrencia

### 1.1 COMMIT explícito
```sql
-- Estado antes
SELECT seccion_id, cupo_disponible FROM seccion WHERE seccion_id = 12;

DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    pkg_inscripciones.inscribir_estudiante(
        p_estudiante_id => 20,
        p_seccion_id    => 12,
        p_resultado     => v_resultado
    );
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/

-- Estado después: el cupo bajó y la inscripción quedó registrada
SELECT seccion_id, cupo_disponible FROM seccion WHERE seccion_id = 12;
```

### 1.2 ROLLBACK ante error (cupo lleno)
```sql
-- Sección 18 tiene cupo_disponible = 0
SELECT seccion_id, cupo_disponible FROM seccion WHERE seccion_id = 18;

DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    pkg_inscripciones.inscribir_estudiante(20, 18, v_resultado);
    DBMS_OUTPUT.PUT_LINE(v_resultado);   -- ERROR: no hay cupo
END;
/

-- El cupo sigue en 0: ningún cambio parcial persistió
SELECT seccion_id, cupo_disponible FROM seccion WHERE seccion_id = 18;
```

### 1.3 READ COMMITTED (dos sesiones)
```sql
-- SESIÓN A
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE seccion SET cupo_disponible = cupo_disponible - 5 WHERE seccion_id = 11;
-- NO hacer COMMIT todavía

-- SESIÓN B (otra conexión): no ve el cambio sin confirmar
SELECT cupo_disponible FROM seccion WHERE seccion_id = 11;

-- SESIÓN A
COMMIT;

-- SESIÓN B: ahora sí ve el valor actualizado
SELECT cupo_disponible FROM seccion WHERE seccion_id = 11;

-- Restaurar
UPDATE seccion SET cupo_disponible = 15 WHERE seccion_id = 11;
COMMIT;
```

### 1.4 SERIALIZABLE (ORA-08177)
```sql
-- SESIÓN A
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT cupo_disponible FROM seccion WHERE seccion_id = 11;

-- SESIÓN B
UPDATE seccion SET cupo_disponible = cupo_disponible - 1 WHERE seccion_id = 11;
COMMIT;

-- SESIÓN A: al intentar modificar el mismo dato
UPDATE seccion SET cupo_disponible = cupo_disponible - 2 WHERE seccion_id = 11;
-- ERROR esperado: ORA-08177 can't serialize access for this transaction
ROLLBACK;
```

### 1.5 Deadlock (ORA-00060)
```sql
-- SESIÓN A
UPDATE seccion SET cupo_disponible = cupo_disponible - 1 WHERE seccion_id = 11;

-- SESIÓN B
UPDATE seccion SET cupo_disponible = cupo_disponible - 1 WHERE seccion_id = 12;
UPDATE seccion SET cupo_disponible = cupo_disponible - 1 WHERE seccion_id = 11; -- espera

-- SESIÓN A
UPDATE seccion SET cupo_disponible = cupo_disponible - 1 WHERE seccion_id = 12;
-- ERROR esperado: ORA-00060 deadlock detected
ROLLBACK;  -- en ambas sesiones
```

---

## 2. PL/SQL, Triggers y Auditoría

### 2.1 Packages y funciones compilados
```sql
SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('PACKAGE','PACKAGE BODY','FUNCTION','TRIGGER')
ORDER BY object_type, object_name;
```

### 2.2 Funciones PL/SQL de apoyo
```sql
SELECT
    fn_promedio_estudiante(1) AS promedio_est_1,
    fn_cupo_disponible(11)    AS cupo_seccion_11,
    fn_estado_aprobacion(16)  AS estado_inscripcion_16
FROM DUAL;
```

### 2.3 Registro de nota con el package
```sql
DECLARE
    v_resultado VARCHAR2(500);
BEGIN
    pkg_notas.registrar_nota(
        p_inscripcion_id  => 16,
        p_tipo_evaluacion => 'Recuperacion',
        p_valor           => 88,
        p_resultado       => v_resultado
    );
    DBMS_OUTPUT.PUT_LINE(v_resultado);
END;
/
```

### 2.4 Trigger de auditoría
```sql
-- Un UPDATE dispara el trigger de auditoría
UPDATE nota SET valor = 80 WHERE nota_id = 1;
COMMIT;

-- La bitácora registra quién, cuándo y qué cambió
SELECT auditoria_id, usuario, operacion, tabla_afectada,
       pk_registro, valor_anterior, valor_nuevo, fecha_hora
FROM auditoria_academica
ORDER BY auditoria_id DESC
FETCH FIRST 5 ROWS ONLY;
```

### 2.5 Trigger de validación de regla de negocio
```sql
-- Intentar una nota fuera de rango (0-100) debe fallar
INSERT INTO nota (inscripcion_id, tipo_evaluacion, valor)
VALUES (16, 'Test', 150);
-- ERROR esperado: ORA-20001 Nota fuera de rango permitido (0-100)
```

---

## 3. Respaldo y Recuperación

### 3.1 Modo ARCHIVELOG (como SYSDBA)
```sql
-- docker exec -it acme-school-db sqlplus / as sysdba
SELECT log_mode FROM v$database;   -- ARCHIVELOG
ARCHIVE LOG LIST;
```

### 3.2 Pérdida y recuperación con Flashback
```sql
ALTER SESSION SET CURRENT_SCHEMA = acme_school;
SET SERVEROUTPUT ON;
VARIABLE scn_bueno NUMBER;

-- Tabla de demostración con datos
CREATE TABLE demo_recovery (id NUMBER, descripcion VARCHAR2(50));
INSERT INTO demo_recovery VALUES (1, 'Registro A');
INSERT INTO demo_recovery VALUES (2, 'Registro B');
INSERT INTO demo_recovery VALUES (3, 'Registro C');
COMMIT;
ALTER TABLE demo_recovery ENABLE ROW MOVEMENT;

-- Guardar el punto de recuperación (SCN con los 3 registros)
BEGIN
    :scn_bueno := DBMS_FLASHBACK.GET_SYSTEM_CHANGE_NUMBER;
END;
/

-- Estado antes
SELECT COUNT(*) AS antes FROM demo_recovery;          -- 3

-- Simular pérdida (DELETE + COMMIT: un ROLLBACK ya no sirve)
DELETE FROM demo_recovery;
COMMIT;
SELECT COUNT(*) AS tras_perdida FROM demo_recovery;   -- 0

-- Recuperar al SCN guardado
FLASHBACK TABLE demo_recovery TO SCN :scn_bueno;
SELECT COUNT(*) AS recuperadas FROM demo_recovery;    -- 3
SELECT * FROM demo_recovery ORDER BY id;

-- Limpieza
DROP TABLE demo_recovery;
```

> **Explicación:** el DELETE confirmado simula una pérdida real. Flashback usa
> el undo tablespace para regresar la tabla a un SCN previo, recuperando los
> datos sin restaurar toda la base (RTO de segundos).

---

## 4. Seguridad y Roles

### 4.1 Roles y usuarios creados (como SYSTEM)
```sql
SELECT role FROM dba_roles WHERE role LIKE 'ROL_%' ORDER BY role;

SELECT grantee, granted_role
FROM dba_role_privs
WHERE granted_role LIKE 'ROL_%'
ORDER BY grantee;
```

### 4.2 GRANT y REVOKE en vivo
```sql
-- El rol docente no tiene acceso a la tabla docente
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';   -- vacío

GRANT SELECT ON acme_school.docente TO rol_docente;      -- conceder
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';   -- SELECT

REVOKE SELECT ON acme_school.docente FROM rol_docente;   -- revocar
SELECT privilege FROM role_tab_privs
WHERE role = 'ROL_DOCENTE' AND table_name = 'DOCENTE';   -- vacío de nuevo
```

### 4.3 Acceso no autorizado (conectado como cada usuario)
```sql
-- Conectar como analista_bi / Analista2025
SHOW USER;
SELECT COUNT(*) FROM acme_school.estudiante;             -- permitido
INSERT INTO acme_school.estudiante (codigo, nombre, apellido)
VALUES ('EST-HACK', 'Intruso', 'Test');                  -- ORA-01031

-- Conectar como docente_mendoza / Docente2025
SHOW USER;
DELETE FROM acme_school.inscripcion WHERE inscripcion_id = 1;  -- ORA-01031

-- Conectar como auditor_sistema / Auditor2025
SHOW USER;
UPDATE acme_school.nota SET valor = 100 WHERE nota_id = 1;      -- ORA-01031
```

---

## 5. Optimización y Rendimiento

### 5.1 EXPLAIN PLAN antes de índices
```sql
SET LINESIZE 200
SET PAGESIZE 100

EXPLAIN PLAN FOR
SELECT e.nombre, e.apellido, c.nombre AS curso, AVG(n.valor) AS promedio
FROM estudiante e
JOIN inscripcion i ON e.estudiante_id = i.estudiante_id
JOIN seccion s     ON i.seccion_id    = s.seccion_id
JOIN curso c       ON s.curso_id      = c.curso_id
JOIN nota n        ON i.inscripcion_id = n.inscripcion_id
GROUP BY e.nombre, e.apellido, c.nombre;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

### 5.2 Índices creados
```sql
SELECT index_name, table_name, column_name
FROM user_ind_columns
WHERE index_name LIKE 'IDX_%'
ORDER BY index_name;
```

### 5.3 EXPLAIN PLAN después (comparar costo/rutas con 5.1)
```sql
EXPLAIN PLAN FOR
SELECT e.nombre, e.apellido, c.nombre AS curso, AVG(n.valor) AS promedio
FROM estudiante e
JOIN inscripcion i ON e.estudiante_id = i.estudiante_id
JOIN seccion s     ON i.seccion_id    = s.seccion_id
JOIN curso c       ON s.curso_id      = c.curso_id
JOIN nota n        ON i.inscripcion_id = n.inscripcion_id
GROUP BY e.nombre, e.apellido, c.nombre;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

### 5.4 Medición de tiempos
```sql
SET TIMING ON
SELECT c.nombre AS curso, ROUND(AVG(n.valor),2) AS promedio, COUNT(*) AS notas
FROM curso c
JOIN seccion s     ON c.curso_id      = s.curso_id
JOIN inscripcion i ON s.seccion_id    = i.seccion_id
JOIN nota n        ON i.inscripcion_id = n.inscripcion_id
GROUP BY c.nombre
ORDER BY promedio DESC;
SET TIMING OFF
```

---

## 6. Data Warehouse y BI

### 6.1 Tablas del modelo estrella
```sql
SELECT table_name FROM user_tables WHERE table_name LIKE 'DW_%' ORDER BY table_name;
```

### 6.2 Datos cargados por el ETL
```sql
SELECT 'dw_dim_estudiante' tabla, COUNT(*) n FROM dw_dim_estudiante UNION ALL
SELECT 'dw_dim_curso',      COUNT(*) FROM dw_dim_curso      UNION ALL
SELECT 'dw_dim_docente',    COUNT(*) FROM dw_dim_docente    UNION ALL
SELECT 'dw_dim_periodo',    COUNT(*) FROM dw_dim_periodo    UNION ALL
SELECT 'dw_fact_inscripciones', COUNT(*) FROM dw_fact_inscripciones UNION ALL
SELECT 'dw_fact_notas',     COUNT(*) FROM dw_fact_notas;
```

### 6.3 KPI 1 — Tasa de aprobación por curso
```sql
SELECT c.nombre AS curso,
       COUNT(*) AS evaluados,
       SUM(CASE WHEN f.aprobado = 1 THEN 1 ELSE 0 END) AS aprobados,
       ROUND(SUM(CASE WHEN f.aprobado = 1 THEN 1 ELSE 0 END)/COUNT(*)*100, 2) AS tasa_aprob_pct
FROM dw_fact_notas f
JOIN dw_dim_curso c ON f.curso_key = c.curso_key
GROUP BY c.nombre
ORDER BY tasa_aprob_pct DESC;
```

### 6.4 KPI 2 — Promedio por docente
```sql
SELECT d.nombre_completo AS docente,
       ROUND(AVG(f.promedio_nota), 2) AS promedio_general
FROM dw_fact_notas f
JOIN dw_dim_docente d ON f.docente_key = d.docente_key
GROUP BY d.nombre_completo
ORDER BY promedio_general DESC;
```

### 6.5 KPI 3 — Inscripciones por período
```sql
SELECT p.nombre AS periodo, COUNT(*) AS total_inscripciones
FROM dw_fact_inscripciones f
JOIN dw_dim_periodo p ON f.periodo_key = p.periodo_key
GROUP BY p.nombre
ORDER BY p.nombre;
```

---

## 7. Alta Disponibilidad

La HA se demuestra en la terminal del servidor (involucra contenedores Docker).

### 7.1 Estado del primario
```bash
docker exec -i acme-school-db sqlplus -s acme_school/AcmeSchool2025@FREEPDB1 <<EOF
SELECT COUNT(*) FROM estudiante;
EXIT;
EOF
```

### 7.2 Simular caída del primario
```bash
docker stop acme-school-db
```

### 7.3 El standby sigue sirviendo los datos
```bash
docker exec -i acme-school-standby sqlplus -s acme_school/AcmeSchool2025@FREEPDB1 <<EOF
SELECT COUNT(*) FROM acme_school.estudiante;
EXIT;
EOF
```

### 7.4 Restaurar el primario
```bash
docker start acme-school-db
```

> **Explicación:** como Oracle Free no incluye Data Guard, se simula HA con un
> contenedor standby que tiene copia de los datos. Al caer el primario, el
> standby responde, demostrando continuidad. Detalles de RPO/RTO en
> `docs/rpo_rto.md`.

---

## Notas

- Si una tabla quedó sin datos por demos previas, recarga con los scripts de
  `sql/oracle/` (03 a 05) antes de presentar.
- Los `inscripcion_id` y `seccion_id` usados aquí asumen el dataset original;
  ajusta los valores si cambiaron tras una demo de recuperación.
