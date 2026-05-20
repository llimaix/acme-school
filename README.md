# ACME School - Sistema de Gestión Académica

## Proyecto Final - Bases de Datos II

Sistema de base de datos empresarial para gestión académica (educación) que integra transacciones, concurrencia, PL/SQL, seguridad, optimización y Data Warehouse sobre Oracle Database.

## Stack Tecnológico

| Componente | Tecnología |
|------------|-----------|
| Base de datos | Oracle Database Free/XE |
| Lenguaje procedural | PL/SQL nativo |
| Backup | RMAN + Data Pump |
| Demo visual (opcional) | Node.js + React |

## Equipo

| Miembro | Responsabilidad Principal |
|---------|--------------------------|
| Wuili | Modelo operacional, Transacciones y Concurrencia |
| Emmanuel | PL/SQL, Triggers, Auditoría, Presentación oral |
| Julian | Optimización y Rendimiento, Data Warehouse y BI |
| Luis | Documento PDF, Seguridad, Backup/Recovery, HA |

## Estructura del Proyecto

```
acme-school/
├── sql/oracle/          # DDL: tablas, secuencias, constraints
├── plsql/               # PL/SQL: packages, functions, triggers
│   ├── packages/        #   pkg_inscripciones, pkg_notas
│   ├── functions/       #   fn_promedio, fn_cupo, fn_aprobacion
│   └── triggers/        #   trg_auditoria, trg_validacion
├── transacciones/       # Scripts de concurrencia y deadlock
├── seguridad/           # Roles, GRANT/REVOKE, acceso no autorizado
├── backup/              # Estrategia RMAN, ARCHIVELOG, recovery
├── optimizacion/        # EXPLAIN PLAN, índices, tiempos
├── dw/                  # Data Warehouse: modelo estrella, ETL, KPIs
├── ha/                  # Alta disponibilidad: diagrama, failover
├── docs/                # Documentación, diagramas, matriz de trabajo
├── evidencias/          # Capturas por sprint
│   ├── sprint-0/
│   ├── sprint-1/
│   ├── sprint-2/
│   └── sprint-3/
├── api/                 # API Node.js (opcional)
├── frontend/            # React (opcional)
├── presentacion/        # Guion y material de presentación
└── PROGRESO.md          # Tracking de avance por tarea
```

## Criterios de Evaluación (15 puntos)

| Criterio | Puntos | Responsable |
|----------|--------|-------------|
| Documento PDF con evidencia | 2 | Luis |
| Transacciones y Control de Concurrencia | 2 | Wuili |
| PL/SQL, Triggers y Auditoría | 2 | Emmanuel |
| Respaldo y Recuperación | 1 | Luis |
| Seguridad y Roles | 1 | Luis |
| Optimización y Rendimiento | 2 | Julian |
| Data Warehouse y BI | 2 | Julian |
| Alta Disponibilidad | 1 | Luis |
| Dominio del tema y claridad | 2 | Emmanuel |

## Cómo Empezar

1. Clonar el repositorio
2. Levantar Oracle Free/XE (Docker recomendado)
3. Ejecutar scripts en orden numérico dentro de `sql/oracle/`
4. Seguir las tareas en `PROGRESO.md`

## Sprints

- **Sprint 0** (Día 1-2): Preparación, ambiente, estructura
- **Sprint 1** (Semana 1-2): Modelo, PL/SQL, transacciones
- **Sprint 2** (Semana 2-3): Seguridad, optimización, DW
- **Sprint 3** (Semana 3): HA, evidencias, presentación
