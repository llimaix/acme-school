# Guía de Conexión - Equipo ACME School

## Datos de Conexión

| Parámetro | Valor |
|-----------|-------|
| **Host** | `<IP_SERVIDOR_AWS>` |
| **Puerto** | `1521` |
| **Service Name** | `FREEPDB1` |
| **SID** | `FREE` |

## Usuarios del Equipo

Cada miembro tiene su propio usuario para trabajar:

| Miembro | Usuario | Password | Permisos |
|---------|---------|----------|----------|
| **Wuili** | `wuili` | `Wuili2025` | SELECT/INSERT/UPDATE en schema, V$LOCK, V$SESSION, DBMS_LOCK |
| **Emmanuel** | `emmanuel` | `Emmanuel2025` | SELECT/INSERT/UPDATE/DELETE, CREATE PROCEDURE/TRIGGER |
| **Julian** | `julian` | `Julian2025` | SELECT/INSERT/UPDATE, EXPLAIN PLAN, DBMS_XPLAN, CREATE INDEX/TABLE/VIEW |
| **Luis** | `luis` | `Luis2025` | CREATE USER/ROLE, GRANT, Data Pump, administración de seguridad |

### Usuario Owner del Schema (para scripts DDL)

| Usuario | Password | Uso |
|---------|----------|-----|
| `acme_school` | `AcmeSchool2025` | Owner de todas las tablas. Usar para DDL y scripts generales |
| `system` | `AcmeSchool2025` | Admin Oracle. Solo para configuración de servidor |

## Cómo Conectarse

### SQL Developer
1. Nueva conexión
2. Name: `ACME - <tu_nombre>`
3. Username: tu usuario
4. Password: tu password
5. Hostname: IP del servidor
6. Port: 1521
7. Service name: FREEPDB1

### SQLcl (línea de comandos)
```bash
sql wuili/Wuili2025@<IP_SERVIDOR>:1521/FREEPDB1
```

### DBeaver
1. Nueva conexión → Oracle
2. Host: IP del servidor
3. Port: 1521
4. Database: FREEPDB1
5. Username/Password: los tuyos

## Schema de Trabajo

Todas las tablas están en el schema `acme_school`. Para acceder:

```sql
-- Opción 1: Prefijo
SELECT * FROM acme_school.estudiante;

-- Opción 2: Cambiar schema de sesión
ALTER SESSION SET CURRENT_SCHEMA = acme_school;
SELECT * FROM estudiante;
```

## Tablas Disponibles

| Tabla | Descripción | Registros |
|-------|-------------|-----------|
| `estudiante` | Estudiantes del sistema | 25 |
| `docente` | Docentes | 8 |
| `curso` | Cursos académicos | 12 |
| `periodo` | Períodos académicos | 4 |
| `seccion` | Secciones por curso/período | 18 |
| `inscripcion` | Inscripciones de estudiantes | ~90 |
| `nota` | Notas/calificaciones | ~100 |
| `auditoria_academica` | Log de auditoría | 0 (se llena con triggers) |

## Usuarios de Demo (para seguridad - Luis)

| Usuario | Rol | Propósito |
|---------|-----|-----------|
| `admin_academico` | rol_admin_academico | CRUD completo |
| `app_academica` | rol_app | Operaciones de la app |
| `docente_mendoza` | rol_docente | Solo notas y consultas |
| `auditor_sistema` | rol_auditor | Solo lectura de auditoría |
| `analista_bi` | rol_reportes | Solo SELECT para reportes |

## Datos Importantes

- **Período ACTIVO**: 2025-1 (para pruebas de inscripción)
- **Sección con cupo LLENO**: seccion_id=18 (BD II sección B, cupo=0)
- **Sección con cupo BAJO**: seccion_id=15 (BD II sección A, cupo=5)
- **Estudiantes RETIRADOS**: inscripcion_id 5, 15, 34, 43, 59 (para probar estados)

## Reglas de Trabajo

1. **NO modificar** tablas directamente en producción sin backup
2. **Usar el schema `acme_school`** para todo
3. **Cada script nuevo** va en `database/init-scripts/` con el prefijo correcto
4. **Push a main** dispara el deploy automático
5. **Si algo se rompe**: avisar y usar `scripts/reset-db.sh`
