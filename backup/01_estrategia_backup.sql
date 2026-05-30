-- Estrategia de backup con RMAN (completo + incremental) y Data Pump.
-- Ejecutar como SYSDBA dentro del contenedor.

-- ============================================================
-- ESTRATEGIA DEFINIDA
-- ============================================================
--
-- | Tipo            | Frecuencia | Herramienta | Retención |
-- |-----------------|------------|-------------|-----------|
-- | Completo        | Semanal    | RMAN        | 7 días    |
-- | Incremental L1  | Diario     | RMAN        | 7 días    |
-- | Archive Logs    | Cada bk    | RMAN        | 7 días    |
-- | Lógico (schema) | Semanal    | Data Pump   | 4 copias  |
--
-- RPO objetivo: ~1 hora (con archive logs activos)
-- RTO objetivo: < 30 minutos (restore + recover)

-- ============================================================
-- PASO 1: CONFIGURACIÓN INICIAL DE RMAN
-- Ejecutar UNA SOLA VEZ desde el servidor:
--   docker exec -it acme-school-db rman target /
-- ============================================================

/*
-- Política de retención: 7 días
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;

-- No respaldar lo que ya está respaldado
CONFIGURE BACKUP OPTIMIZATION ON;

-- Autobackup del controlfile en cada operación
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK
  TO '/opt/oracle/backups/cf_%F';

-- Formato general de backups
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT '/opt/oracle/backups/%U';

-- Verificar configuración
SHOW ALL;
*/

-- ============================================================
-- PASO 2: BACKUP COMPLETO SEMANAL
-- Programar cada domingo:
-- ============================================================

/*
RUN {
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK;
  BACKUP AS COMPRESSED BACKUPSET
    DATABASE
    FORMAT '/opt/oracle/backups/full_%T_%U'
    TAG 'WEEKLY_FULL';
  BACKUP ARCHIVELOG ALL
    FORMAT '/opt/oracle/backups/arch_%T_%U'
    TAG 'ARCH_WEEKLY'
    DELETE INPUT;
  BACKUP CURRENT CONTROLFILE
    FORMAT '/opt/oracle/backups/ctrl_%T_%U';
}
*/

-- ============================================================
-- PASO 3: BACKUP INCREMENTAL DIARIO
-- Programar de lunes a sábado:
-- ============================================================

/*
RUN {
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK;
  BACKUP INCREMENTAL LEVEL 1
    DATABASE
    FORMAT '/opt/oracle/backups/incr_%T_%U'
    TAG 'DAILY_INCR';
  BACKUP ARCHIVELOG ALL
    FORMAT '/opt/oracle/backups/arch_%T_%U'
    DELETE INPUT;
}
*/

-- ============================================================
-- PASO 4: BACKUP LÓGICO CON DATA PUMP
-- Complemento al backup físico (útil para migración o
-- restauración selectiva de objetos)
-- Ejecutar desde shell del contenedor:
-- ============================================================

/*
docker exec acme-school-db bash -c "
  expdp acme_school/AcmeSchool2025@FREEPDB1 \
    DIRECTORY=backup_dir \
    DUMPFILE=acme_school_$(date +%Y%m%d).dmp \
    LOGFILE=acme_school_$(date +%Y%m%d).log \
    SCHEMAS=acme_school \
    COMPRESSION=ALL
"
*/

-- ============================================================
-- PASO 5: VERIFICACIÓN PERIÓDICA DE BACKUPS
-- Ejecutar cada lunes para validar:
-- ============================================================

/*
-- Listar backups disponibles
LIST BACKUP SUMMARY;
LIST BACKUP OF DATABASE;
LIST BACKUP OF ARCHIVELOG ALL;

-- Reportar archivos que necesitan respaldo
REPORT NEED BACKUP;
REPORT OBSOLETE;

-- Validar integridad de los backups
CROSSCHECK BACKUP;
VALIDATE BACKUPSET ALL;

-- Eliminar backups obsoletos según política
DELETE NOPROMPT OBSOLETE;
*/

-- ============================================================
-- AUTOMATIZACIÓN
-- ============================================================
-- El script database/scripts/ci-deploy.sh genera un export
-- pre-deploy automáticamente cada vez que se actualiza la BD.
--
-- Para programar en producción (crontab):
--
--   # Lunes a sábado 02:00 - Backup incremental
--   0 2 * * 1-6 /opt/sv-db/database/scripts/rman_incremental.sh
--
--   # Domingo 02:00 - Backup completo
--   0 2 * * 0   /opt/sv-db/database/scripts/rman_full.sh

-- ============================================================
-- EVIDENCIA REQUERIDA PARA EL PDF
-- ============================================================
-- 1. Captura de SHOW ALL en RMAN (configuración)
-- 2. Salida de BACKUP DATABASE exitoso
-- 3. Salida de LIST BACKUP SUMMARY mostrando los respaldos
-- 4. Tamaño de los archivos generados en /opt/oracle/backups/
