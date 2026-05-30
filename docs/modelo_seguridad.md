# Modelo de Seguridad - ACME School

## Principio de diseño

El modelo se basa en **mínimo privilegio**: cada rol solo recibe los permisos estrictamente necesarios para cumplir su función. Ningún usuario funcional usa SYS o SYSTEM.

## Roles definidos

| Rol | Propósito | Tipo de acceso |
|-----|-----------|----------------|
| `rol_admin_academico` | Administración total del schema operacional | CRUD completo |
| `rol_app` | Backend de la aplicación | Lectura general + escritura controlada |
| `rol_docente` | Profesores que registran notas | Consulta + INSERT/UPDATE en notas |
| `rol_auditor` | Auditoría del sistema | Solo lectura, incluye auditoría |
| `rol_reportes` | Analítica y BI | Solo lectura sobre operacional |

## Matriz de privilegios

| Tabla | admin | app | docente | auditor | reportes |
|-------|-------|-----|---------|---------|----------|
| `estudiante` | CRUD | R | R | R | R |
| `docente` | CRUD | R | — | — | R |
| `curso` | CRUD | R | R | — | R |
| `periodo` | CRUD | R | R | — | R |
| `seccion` | CRUD | R + U(cupo) | R | — | R |
| `inscripcion` | CRUD | R, I, U | R | R | R |
| `nota` | CRUD | R, I, U | R, I, U | R | R |
| `auditoria_academica` | R | — | — | R | — |

**Leyenda:** C=Create, R=Read, U=Update, D=Delete, I=Insert. Guion (—) = sin acceso.

## Usuarios y asignación de roles

| Usuario | Rol | Password | Uso |
|---------|-----|----------|-----|
| `admin_academico` | `rol_admin_academico` | AdminAcad2025 | Administrador funcional |
| `app_academica` | `rol_app` | AppAcad2025 | Conexión del backend |
| `docente_mendoza` | `rol_docente` | Docente2025 | Ejemplo de docente |
| `auditor_sistema` | `rol_auditor` | Auditor2025 | Auditor interno |
| `analista_bi` | `rol_reportes` | Analista2025 | Reportes y BI |

> Las contraseñas son de demo. En producción deben rotarse y guardarse en un secret manager.

## Justificación de cada decisión

### `rol_admin_academico` con CRUD completo
Necesario para gestión real del catálogo (cursos, períodos, secciones). No tiene `DELETE` sobre auditoría: incluso el admin no puede borrar evidencia.

### `rol_app` con UPDATE limitado a `cupo_disponible`
La aplicación necesita decrementar/incrementar cupo al inscribir y retirar, pero no debe poder cambiar `cupo_maximo`, `docente_id` ni otros campos. Se usa `GRANT UPDATE (cupo_disponible)` (column-level).

### `rol_docente` sin acceso a `docente`
Un profesor solo necesita ver sus propios datos, no la lista de colegas. Tampoco puede borrar notas: si hay error, el admin corrige.

### `rol_auditor` solo lectura
Un auditor que pueda escribir contamina la evidencia. Por eso el rol es de solo lectura sobre `auditoria_academica` y las tablas relacionadas.

### `rol_reportes` sin acceso a auditoría
Los datos de auditoría son sensibles (revelan quién hizo qué cuándo). Un analista de reportes solo necesita los datos operacionales.

## Pruebas de seguridad

Documentadas en `seguridad/03_acceso_no_autorizado.sql`. Resumen:

| # | Usuario | Operación | Error esperado |
|---|---------|-----------|----------------|
| 1 | analista_bi | INSERT en estudiante | ORA-01031 |
| 2 | docente_mendoza | DROP TABLE estudiante | ORA-01031 |
| 3 | docente_mendoza | DELETE en inscripcion | ORA-01031 |
| 4 | auditor_sistema | UPDATE en nota | ORA-01031 |
| 5 | app_academica | SELECT en auditoria | ORA-00942 |
| 6 | docente_mendoza | UPDATE en seccion | ORA-01031 |

## Recomendaciones de hardening adicional

Estas mejoras quedan documentadas para producción real:

1. **Profile con expiración de password**: `CREATE PROFILE acad_profile LIMIT PASSWORD_LIFE_TIME 90`
2. **Auditoría unificada de logins fallidos**: `AUDIT POLICY login_failures` sobre `LOGON STATEMENT FAILURE`
3. **Bloqueo automático tras intentos fallidos**: `FAILED_LOGIN_ATTEMPTS 5`
4. **Encriptación TDE** sobre tablespace `acme_data` para datos en reposo
5. **VPD (Virtual Private Database)** si se quiere aislar visibilidad por sección o docente

## Verificación rápida

```sql
-- Ver roles del proyecto
SELECT role FROM dba_roles WHERE role LIKE 'ROL_%';

-- Ver privilegios por rol
SELECT role, privilege, table_name
FROM role_tab_privs
WHERE role LIKE 'ROL_%'
ORDER BY role, table_name;

-- Ver asignación de roles a usuarios
SELECT grantee, granted_role
FROM dba_role_privs
WHERE granted_role LIKE 'ROL_%';
```
