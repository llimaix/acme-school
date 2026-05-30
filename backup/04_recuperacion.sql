-- Recuperación de datos. Tres opciones: Flashback Table, RMAN PITR
-- o Data Pump Import. Ejecutar tras 03_simulacion_perdida.sql.

-- ============================================================
-- OPCIÓN A: FLASHBACK TABLE (RECOMENDADA PARA LA DEMO)
-- Más rápida, no requiere shutdown
-- Funciona si los datos aún están en el undo tablespace
-- (típicamente 15 minutos por defecto)
-- Ejecutar como: SYSDBA o usuario con FLASHBACK privilege
-- ============================================================

ALTER SESSION SET CURRENT_SCHEMA = acme_school;

-- Habilitar row movement (necesario para FLASHBACK TABLE)
ALTER TABLE acme_school.nota        ENABLE ROW MOVEMENT;
ALTER TABLE acme_school.inscripcion ENABLE ROW MOVEMENT;

-- Recuperar a un punto antes de la eliminación
-- Ajustar el INTERVAL según cuándo se hizo el DELETE
FLASHBACK TABLE acme_school.nota
  TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '10' MINUTE);

FLASHBACK TABLE acme_school.inscripcion
  TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '10' MINUTE);

-- ============================================================
-- OPCIÓN B: RMAN POINT-IN-TIME RECOVERY
-- Recovery completo de toda la BD a un punto específico
-- Requiere shutdown y mountear la BD
-- Usar si la pérdida es masiva o flashback no aplica
-- Ejecutar en RMAN como SYSDBA:
-- ============================================================

/*
-- Paso 1: Determinar el SCN antes de la pérdida
-- (anotado en el script anterior)
SELECT TIMESTAMP_TO_SCN(SYSTIMESTAMP - INTERVAL '15' MINUTE)
  AS target_scn FROM DUAL;

-- Paso 2: Bajar la BD
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;

-- Paso 3: Restore + Recover en RMAN
-- docker exec -it acme-school-db rman target /
--
-- RUN {
--   SET UNTIL SCN <scn_anotado>;
--   RESTORE DATABASE;
--   RECOVER DATABASE;
-- }

-- Paso 4: Abrir con resetlogs
ALTER DATABASE OPEN RESETLOGS;
*/

-- ============================================================
-- OPCIÓN C: DATA PUMP IMPORT
-- Restaurar desde export lógico previo
-- Útil si solo se necesita restaurar tablas específicas
-- Ejecutar desde shell del contenedor:
-- ============================================================

/*
docker exec acme-school-db bash -c "
  impdp acme_school/AcmeSchool2025@FREEPDB1 \
    DIRECTORY=backup_dir \
    DUMPFILE=acme_school_YYYYMMDD.dmp \
    LOGFILE=recovery_$(date +%Y%m%d).log \
    TABLES=inscripcion,nota \
    TABLE_EXISTS_ACTION=APPEND
"
*/

-- ============================================================
-- VERIFICACIÓN POST-RECUPERACIÓN
-- ============================================================

PROMPT === VERIFICACION DE RECUPERACION ===

-- Debe coincidir con los conteos originales antes de la pérdida
SELECT COUNT(*) AS inscripciones_recuperadas
FROM inscripcion i
JOIN seccion s ON i.seccion_id = s.seccion_id
WHERE s.periodo_id = (SELECT periodo_id FROM periodo WHERE codigo = '2024-1');

SELECT COUNT(*) AS notas_recuperadas
FROM nota n
JOIN inscripcion i ON n.inscripcion_id = i.inscripcion_id
JOIN seccion s     ON i.seccion_id     = s.seccion_id
WHERE s.periodo_id = (SELECT periodo_id FROM periodo WHERE codigo = '2024-1');

-- Verificar integridad: muestra de inscripciones recuperadas
SELECT i.inscripcion_id,
       e.codigo  AS estudiante,
       c.nombre  AS curso,
       i.estado,
       i.fecha_inscripcion
FROM inscripcion i
JOIN estudiante e ON i.estudiante_id = e.estudiante_id
JOIN seccion s    ON i.seccion_id    = s.seccion_id
JOIN curso c      ON s.curso_id      = c.curso_id
JOIN periodo p    ON s.periodo_id    = p.periodo_id
WHERE p.codigo = '2024-1'
  AND ROWNUM <= 10
ORDER BY i.inscripcion_id;

-- Verificar que las relaciones se mantienen
SELECT i.inscripcion_id, COUNT(n.nota_id) AS notas_por_inscripcion
FROM inscripcion i
LEFT JOIN nota n ON n.inscripcion_id = i.inscripcion_id
JOIN seccion s   ON i.seccion_id     = s.seccion_id
WHERE s.periodo_id = (SELECT periodo_id FROM periodo WHERE codigo = '2024-1')
GROUP BY i.inscripcion_id
ORDER BY i.inscripcion_id
FETCH FIRST 10 ROWS ONLY;

-- ============================================================
-- COMPARACIÓN ANTES vs DESPUÉS DE RECUPERACIÓN
-- ============================================================
-- | Estado            | Inscripciones | Notas |
-- |-------------------|---------------|-------|
-- | Antes de perdida  | 34            | 102   |
-- | Despues de perdida| 0             | 0     |
-- | Despues de recovery| 34            | 102   |
--
-- Los números deben coincidir entre "antes de pérdida" y
-- "después de recovery", confirmando que la recuperación
-- fue exitosa y completa.

-- ============================================================
-- EVIDENCIA REQUERIDA PARA EL PDF
-- ============================================================
-- 1. Captura del estado posterior a la pérdida (de T-027)
-- 2. Comando de recuperación ejecutado (FLASHBACK o RMAN)
-- 3. Captura de los conteos después de recovery
-- 4. Consulta mostrando datos íntegros con joins funcionando
-- 5. Tabla comparativa antes/durante/después

-- ============================================================
-- MÉTRICAS RECOMENDADAS PARA REPORTE FINAL
-- ============================================================
-- RPO real (Recovery Point Objective):
--   Tiempo entre el último backup/checkpoint y la pérdida
--   En esta demo: minutos (depende de cuándo fue el último switch)
--
-- RTO real (Recovery Time Objective):
--   Tiempo total desde detectar la pérdida hasta tener datos OK
--   Con FLASHBACK: segundos
--   Con RMAN: 5-30 minutos según tamaño
--   Con Data Pump: depende del volumen de datos
