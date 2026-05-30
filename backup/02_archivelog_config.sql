-- ============================================================
-- ACME SCHOOL - Sistema de Gestión Académica
-- Script: backup/02_archivelog_config.sql
-- Responsable: Luis
-- Tarea: T-026
-- Descripción: Habilitar modo ARCHIVELOG para recovery
--   point-in-time y respaldos online consistentes
-- Ejecutar como: SYSDBA dentro del contenedor
-- ============================================================

-- ============================================================
-- ¿QUÉ ES ARCHIVELOG?
-- ============================================================
-- Oracle escribe TODOS los cambios en redo logs online.
-- En modo NOARCHIVELOG, esos logs se sobreescriben cíclicamente,
-- perdiendo el historial necesario para recovery completo.
-- En modo ARCHIVELOG, Oracle copia (archiva) cada redo log
-- antes de reusarlo, manteniendo el historial completo.
--
-- BENEFICIOS:
--   * Recovery point-in-time (restaurar a cualquier momento)
--   * Backups online (sin parar la BD)
--   * Backups incrementales con RMAN
--   * Replicación con Data Guard (si se usa)

-- ============================================================
-- VERIFICACIÓN PREVIA
-- Ejecutar como sysdba para ver el modo actual:
-- ============================================================

-- SELECT log_mode FROM v$database;
-- ARCHIVE LOG LIST;
--
-- Si log_mode = NOARCHIVELOG, proceder con la habilitación.

-- ============================================================
-- HABILITAR ARCHIVELOG
-- Requiere reiniciar la base de datos.
-- Ejecutar dentro del contenedor:
--   docker exec -it acme-school-db sqlplus / as sysdba
-- ============================================================

/*
-- Paso 1: Bajar la BD limpiamente
SHUTDOWN IMMEDIATE;

-- Paso 2: Montar sin abrir
STARTUP MOUNT;

-- Paso 3: Cambiar a modo ARCHIVELOG
ALTER DATABASE ARCHIVELOG;

-- Paso 4: Abrir la BD
ALTER DATABASE OPEN;

-- Paso 5: Configurar destino de archivos
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1='LOCATION=/opt/oracle/archivelog'
  SCOPE=BOTH;

-- Paso 6: Definir formato de nombres
ALTER SYSTEM SET LOG_ARCHIVE_FORMAT='arch_%t_%s_%r.arc'
  SCOPE=SPFILE;

-- Paso 7: Forzar primer switch para validar
ALTER SYSTEM SWITCH LOGFILE;
ALTER SYSTEM CHECKPOINT;
*/

-- ============================================================
-- VERIFICACIÓN DESPUÉS DE HABILITAR
-- ============================================================

/*
-- Modo de la BD
SELECT log_mode FROM v$database;
-- Resultado esperado: ARCHIVELOG

-- Estado de archivado
ARCHIVE LOG LIST;
-- Resultado esperado:
--   Database log mode              Archive Mode
--   Automatic archival             Enabled
--   Archive destination            /opt/oracle/archivelog
--   Oldest online log sequence     X
--   Next log sequence to archive   Y
--   Current log sequence           Z

-- Listar archive logs generados
SELECT name, sequence#, first_change#, next_change#,
       to_char(first_time, 'YYYY-MM-DD HH24:MI:SS') AS fecha
FROM v$archived_log
ORDER BY sequence# DESC
FETCH FIRST 10 ROWS ONLY;
*/

-- ============================================================
-- CONFIGURAR RMAN PARA APROVECHAR ARCHIVELOG
-- ============================================================

/*
-- En RMAN:
docker exec -it acme-school-db rman target /

CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
CONFIGURE BACKUP OPTIMIZATION ON;
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK
  TO '/opt/oracle/backups/cf_%F';

SHOW ALL;
*/

-- ============================================================
-- CONSIDERACIONES OPERATIVAS
-- ============================================================
--
-- 1. ESPACIO EN DISCO
--    Los archive logs ocupan espacio. Monitorear con:
--      SELECT * FROM v$flash_recovery_area_usage;
--    Limpiar regularmente con RMAN:
--      DELETE NOPROMPT ARCHIVELOG ALL COMPLETED BEFORE 'sysdate-7';
--
-- 2. SI EL DESTINO SE LLENA
--    La BD se detiene. Prevenir con:
--      - Espacio suficiente en /opt/oracle/archivelog
--      - Política de retención clara
--      - Alarma de monitoreo de disco
--
-- 3. EN PRODUCCIÓN MULTIPLEXAR
--    Configurar más de un destino:
--      ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='LOCATION=/backup_remoto';

-- ============================================================
-- EVIDENCIA REQUERIDA PARA EL PDF
-- ============================================================
-- 1. Captura de SELECT log_mode FROM v$database; ANTES (NOARCHIVELOG)
-- 2. Captura de los comandos ALTER DATABASE ARCHIVELOG
-- 3. Captura de SELECT log_mode FROM v$database; DESPUÉS (ARCHIVELOG)
-- 4. Captura de ARCHIVE LOG LIST
-- 5. Listado de archive logs generados después de varios switches
