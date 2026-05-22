-- ============================================================
-- ACME SCHOOL - Infraestructura de Base de Datos
-- Script: 01_create_schema.sql
-- Ejecutar como: SYSTEM
-- Propósito: Preparar el ambiente para que el equipo trabaje
--   NO incluye tareas del proyecto (seguridad, backup, etc.)
-- ============================================================

-- ==================== TABLESPACE ====================
CREATE TABLESPACE acme_data
  DATAFILE '/opt/oracle/oradata/FREE/acme_data01.dbf'
  SIZE 200M AUTOEXTEND ON NEXT 100M MAXSIZE 4G;

CREATE TABLESPACE acme_dw
  DATAFILE '/opt/oracle/oradata/FREE/acme_dw01.dbf'
  SIZE 100M AUTOEXTEND ON NEXT 50M MAXSIZE 2G;

-- ==================== SCHEMA OWNER ====================
-- Este es el usuario dueño de todas las tablas del proyecto
CREATE USER acme_school IDENTIFIED BY AcmeSchool2025
  DEFAULT TABLESPACE acme_data
  TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON acme_data
  QUOTA UNLIMITED ON acme_dw;

-- Privilegios completos de desarrollo
GRANT CREATE SESSION TO acme_school;
GRANT CREATE TABLE TO acme_school;
GRANT CREATE VIEW TO acme_school;
GRANT CREATE SEQUENCE TO acme_school;
GRANT CREATE PROCEDURE TO acme_school;
GRANT CREATE TRIGGER TO acme_school;
GRANT CREATE TYPE TO acme_school;
GRANT CREATE SYNONYM TO acme_school;
GRANT CREATE DATABASE LINK TO acme_school;
GRANT CREATE MATERIALIZED VIEW TO acme_school;
GRANT CREATE ROLE TO acme_school;

-- Vistas de rendimiento (para EXPLAIN PLAN, DBMS_XPLAN)
GRANT SELECT ON V_$SESSION TO acme_school;
GRANT SELECT ON V_$SQL TO acme_school;
GRANT SELECT ON V_$SQL_PLAN TO acme_school;
GRANT SELECT ON V_$SQL_PLAN_STATISTICS_ALL TO acme_school;
GRANT SELECT ON V_$STATNAME TO acme_school;
GRANT SELECT ON V_$MYSTAT TO acme_school;
GRANT SELECT ON V_$LOCK TO acme_school;
GRANT SELECT ON V_$TRANSACTION TO acme_school;
GRANT SELECT_CATALOG_ROLE TO acme_school;

-- Packages del sistema necesarios
GRANT EXECUTE ON DBMS_XPLAN TO acme_school;
GRANT EXECUTE ON DBMS_OUTPUT TO acme_school;
GRANT EXECUTE ON DBMS_LOCK TO acme_school;
GRANT EXECUTE ON UTL_FILE TO acme_school;

-- Para Data Pump (backups)
GRANT DATAPUMP_EXP_FULL_DATABASE TO acme_school;
GRANT DATAPUMP_IMP_FULL_DATABASE TO acme_school;

-- Para crear usuarios/roles (necesario para tareas de seguridad)
GRANT CREATE USER TO acme_school;
GRANT CREATE ROLE TO acme_school;
GRANT GRANT ANY ROLE TO acme_school;
GRANT GRANT ANY PRIVILEGE TO acme_school;
GRANT ALTER USER TO acme_school;
GRANT DROP USER TO acme_school;

-- Directorio para backups
CREATE OR REPLACE DIRECTORY backup_dir AS '/opt/oracle/backups';
GRANT READ, WRITE ON DIRECTORY backup_dir TO acme_school;

-- ==================== USUARIOS DEL EQUIPO ====================
-- Cada miembro se conecta con su usuario personal
-- Todos trabajan sobre el schema acme_school

CREATE USER wuili IDENTIFIED BY Wuili2025
  DEFAULT TABLESPACE acme_data TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON acme_data;
GRANT CREATE SESSION TO wuili;
GRANT SELECT ANY TABLE TO wuili;
GRANT INSERT ANY TABLE TO wuili;
GRANT UPDATE ANY TABLE TO wuili;
GRANT DELETE ANY TABLE TO wuili;
GRANT SELECT ON V_$LOCK TO wuili;
GRANT SELECT ON V_$SESSION TO wuili;
GRANT SELECT ON V_$TRANSACTION TO wuili;
GRANT EXECUTE ON DBMS_LOCK TO wuili;

CREATE USER emmanuel IDENTIFIED BY Emmanuel2025
  DEFAULT TABLESPACE acme_data TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON acme_data;
GRANT CREATE SESSION TO emmanuel;
GRANT SELECT ANY TABLE TO emmanuel;
GRANT INSERT ANY TABLE TO emmanuel;
GRANT UPDATE ANY TABLE TO emmanuel;
GRANT DELETE ANY TABLE TO emmanuel;
GRANT CREATE ANY PROCEDURE TO emmanuel;
GRANT CREATE ANY TRIGGER TO emmanuel;
GRANT ALTER ANY TRIGGER TO emmanuel;
GRANT EXECUTE ANY PROCEDURE TO emmanuel;
GRANT EXECUTE ON DBMS_OUTPUT TO emmanuel;

CREATE USER julian IDENTIFIED BY Julian2025
  DEFAULT TABLESPACE acme_data TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON acme_data
  QUOTA UNLIMITED ON acme_dw;
GRANT CREATE SESSION TO julian;
GRANT SELECT ANY TABLE TO julian;
GRANT INSERT ANY TABLE TO julian;
GRANT UPDATE ANY TABLE TO julian;
GRANT SELECT ON V_$SESSION TO julian;
GRANT SELECT ON V_$SQL TO julian;
GRANT SELECT ON V_$SQL_PLAN TO julian;
GRANT EXECUTE ON DBMS_XPLAN TO julian;
GRANT CREATE ANY INDEX TO julian;
GRANT CREATE TABLE TO julian;
GRANT CREATE VIEW TO julian;
GRANT CREATE MATERIALIZED VIEW TO julian;
GRANT CREATE SEQUENCE TO julian;

CREATE USER luis IDENTIFIED BY Luis2025
  DEFAULT TABLESPACE acme_data TEMPORARY TABLESPACE temp
  QUOTA UNLIMITED ON acme_data;
GRANT CREATE SESSION TO luis;
GRANT SELECT ANY TABLE TO luis;
GRANT INSERT ANY TABLE TO luis;
GRANT UPDATE ANY TABLE TO luis;
GRANT DELETE ANY TABLE TO luis;
GRANT CREATE USER TO luis;
GRANT CREATE ROLE TO luis;
GRANT GRANT ANY ROLE TO luis;
GRANT GRANT ANY PRIVILEGE TO luis;
GRANT ALTER USER TO luis;
GRANT DROP USER TO luis;
GRANT READ, WRITE ON DIRECTORY backup_dir TO luis;
GRANT DATAPUMP_EXP_FULL_DATABASE TO luis;
GRANT DATAPUMP_IMP_FULL_DATABASE TO luis;

COMMIT;
