# ACME School — Sistema de Gestión Académica

Proyecto final de Bases de Datos II. Sistema sobre Oracle Database que integra
transacciones y concurrencia, PL/SQL, seguridad, respaldo/recuperación,
optimización, Data Warehouse y alta disponibilidad.

## Stack

| Componente | Tecnología |
|------------|-----------|
| Base de datos | Oracle Database 23ai Free |
| Lenguaje procedural | PL/SQL |
| Respaldo | RMAN + Data Pump |
| Infraestructura | Docker + GitHub Actions |

## Equipo

| Miembro | Responsabilidad |
|---------|-----------------|
| Wuili | Modelo operacional, transacciones y concurrencia |
| Emmanuel | PL/SQL, triggers, auditoría, presentación |
| Julian | Optimización, Data Warehouse y BI |
| Luis | Seguridad, respaldo/recuperación, alta disponibilidad, documento final |

📁 [Drive del equipo](https://drive.google.com/drive/folders/16rHEn51XvgTSbqQU-ugPDeBr0egviJHS?usp=drive_link)

## Estructura

```
acme-school/
├── sql/oracle/      # DDL: secuencias, tablas, datos y validación
├── plsql/           # Packages, funciones y triggers
├── transacciones/   # COMMIT/ROLLBACK, aislamiento y deadlock
├── seguridad/       # Roles, GRANT/REVOKE, acceso no autorizado
├── backup/          # RMAN, ARCHIVELOG, pérdida y recuperación
├── optimizacion/    # Consultas, EXPLAIN PLAN, índices
├── dw/              # Modelo estrella, ETL y KPIs
├── ha/              # Simulación de failover
├── database/        # Infraestructura Docker (Oracle)
├── docs/            # Documentación del proyecto
└── evidencias/      # Capturas por sprint
```

## Documentación

| Tema | Documento |
|------|-----------|
| Trazabilidad y checklist de criterios | [docs/trazabilidad.md](docs/trazabilidad.md) |
| Guía de demostración (consultas por criterio) | [docs/guia_demostracion.md](docs/guia_demostracion.md) |
| Diagrama entidad-relación | [docs/diagrama_er.md](docs/diagrama_er.md) |
| Diccionario de datos | [docs/diccionario_datos.md](docs/diccionario_datos.md) |
| PL/SQL (packages, funciones, triggers) | [docs/plsql_documentacion.md](docs/plsql_documentacion.md) |
| Modelo de seguridad | [docs/modelo_seguridad.md](docs/modelo_seguridad.md) |
| Arquitectura de alta disponibilidad | [docs/arquitectura_ha.md](docs/arquitectura_ha.md) |
| Diagrama del balanceador (HAProxy) | [docs/diagrama_balanceador.md](docs/diagrama_balanceador.md) |
| Failover, RPO y RTO | [docs/rpo_rto.md](docs/rpo_rto.md) |
| Infraestructura de base de datos | [docs/infraestructura_db.md](docs/infraestructura_db.md) |
| Recursos del equipo | [docs/recursos_equipo.md](docs/recursos_equipo.md) |

## Orden de ejecución

Conectado como `acme_school`, ejecutar en este orden:

1. `sql/oracle/01_create_sequences.sql`
2. `sql/oracle/02_create_tables.sql`
3. `sql/oracle/03_insert_data.sql`
4. `sql/oracle/04_insert_inscripciones_notas.sql`
5. `sql/oracle/05_insert_notas.sql`
6. `sql/oracle/06_constraints_validation.sql`
7. `plsql/**` (funciones, packages, triggers)
8. `seguridad/`, `optimizacion/`, `dw/` según el criterio a demostrar

La infraestructura Oracle en Docker se documenta en [docs/infraestructura_db.md](docs/infraestructura_db.md).

## Criterios de evaluación

| Criterio | Puntos | Carpeta |
|----------|--------|---------|
| Documento PDF con evidencia | 2 | `evidencias/` |
| Transacciones y control de concurrencia | 2 | `transacciones/` |
| PL/SQL, triggers y auditoría | 2 | `plsql/` |
| Respaldo y recuperación | 1 | `backup/` |
| Seguridad y roles | 1 | `seguridad/` |
| Optimización y rendimiento | 2 | `optimizacion/` |
| Data Warehouse y BI | 2 | `dw/` |
| Alta disponibilidad | 1 | `ha/` |
| Dominio del tema y claridad | 2 | `presentacion/` |

El estado detallado de cada criterio está en [docs/trazabilidad.md](docs/trazabilidad.md).
