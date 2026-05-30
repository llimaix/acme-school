# Trazabilidad y Checklist del Proyecto

Vincula cada criterio de la rúbrica con su evidencia y refleja el estado final.

## Criterio → Evidencia

| # | Criterio | Pts | Scripts / Documentos | Evidencia |
|---|----------|-----|----------------------|-----------|
| 1 | Documento PDF con evidencia | 2 | Todo el repositorio | `evidencias/` |
| 2 | Transacciones y concurrencia | 2 | `transacciones/01-06_*.sql` | `evidencias/sprint-1/` |
| 3 | PL/SQL, triggers y auditoría | 2 | `plsql/**`, `docs/plsql_documentacion.md` | `evidencias/sprint-1/` |
| 4 | Respaldo y recuperación | 1 | `backup/01-04_*.sql` | `evidencias/sprint-2/` |
| 5 | Seguridad y roles | 1 | `seguridad/*.sql`, `docs/modelo_seguridad.md` | `evidencias/sprint-2/` |
| 6 | Optimización y rendimiento | 2 | `optimizacion/01-05_*.sql` | `evidencias/sprint-2/` |
| 7 | Data Warehouse y BI | 2 | `dw/01-03_*.sql`, `docs/diagrama_er.md` | `evidencias/sprint-2/` |
| 8 | Alta disponibilidad | 1 | `ha/`, `docs/arquitectura_ha.md`, `docs/rpo_rto.md` | `evidencias/sprint-3/` |
| 9 | Dominio del tema y claridad | 2 | `presentacion/` | Evaluación oral |

## Checklist por tarea

### Sprint 0 — Preparación
- [x] T-001 Alcance del sistema definido
- [x] T-002 Oracle PL/SQL como motor
- [x] T-003 Repositorio y estructura
- [x] T-004 Ambiente Oracle (Docker)
- [x] T-005 Matriz de trazabilidad

> Sprint 0 no tiene capturas propias; queda evidenciado de forma implícita al estar el Sprint 1 completo y funcional.

### Sprint 1 — Modelo, PL/SQL y Transacciones
- [x] T-006 Diagrama ER
- [x] T-007 Diccionario de datos
- [x] T-008 DDL (secuencias, tablas, constraints)
- [x] T-009 Dataset de prueba
- [x] T-010 Pruebas de integridad
- [x] T-011 Package pkg_inscripciones
- [x] T-012 COMMIT exitoso
- [x] T-013 ROLLBACK ante error
- [x] T-014 READ COMMITTED
- [x] T-015 SERIALIZABLE
- [x] T-016 Deadlock ORA-00060
- [x] T-017 Solución del deadlock
- [x] T-018 Package pkg_notas
- [x] T-019 Funciones PL/SQL
- [x] T-020 Tabla de auditoría
- [x] T-021 Trigger de auditoría
- [x] T-022 Trigger de validación
- [x] T-023 Manejo de excepciones
- [x] T-024 Documentación PL/SQL

### Sprint 2 — Seguridad, Optimización y DW
- [x] T-025 Estrategia de backup RMAN
- [x] T-026 Configuración ARCHIVELOG
- [x] T-027 Simulación de pérdida
- [x] T-028 Recuperación de datos
- [x] T-029 Roles y usuarios
- [x] T-030 GRANT y REVOKE
- [x] T-031 Acceso no autorizado
- [x] T-032 Documentación de seguridad
- [x] T-033 Consultas críticas
- [x] T-034 EXPLAIN PLAN antes
- [x] T-035 Medición de tiempos
- [x] T-036 Índices estratégicos
- [x] T-037 EXPLAIN PLAN después
- [x] T-038 Reescritura SQL
- [x] T-039 Modelo dimensional
- [x] T-040 DDL del DW
- [x] T-041 ETL operacional → DW
- [x] T-042 KPIs estratégicos
- [x] T-043 Vistas/consultas BI
- [ ] T-044 Diagrama del flujo ETL (pendiente)

### Sprint 3 — Alta Disponibilidad y Presentación
- [x] T-045 Arquitectura HA
- [x] T-046 Failover, RPO y RTO
- [x] T-047 Simulación de failover
- [ ] T-048 API Node.js (opcional, no implementado)
- [ ] T-049 Frontend React (opcional, no implementado)
- [ ] T-050 PDF final consolidado (en proceso)

## Pendientes

| Tarea | Estado | Nota |
|-------|--------|------|
| T-044 | Pendiente | El flujo ETL está implementado en `dw/02_etl_carga.sql`; falta el diagrama |
| T-048 / T-049 | No implementado | Demo Node/React era opcional según la rúbrica |
| T-050 | En proceso | Consolidación del PDF con las evidencias de los tres sprints |
