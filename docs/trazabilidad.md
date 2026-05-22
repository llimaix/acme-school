# Matriz de Trazabilidad: Criterio → Evidencia → Responsable

## Tarea: T-005 | Responsable: Luis

Esta tabla vincula cada criterio de la rúbrica con la evidencia requerida, los scripts que la generan, y el responsable de entregarla.

---

| # | Criterio (Rúbrica) | Pts | Evidencia Requerida | Scripts / Archivos | Capturas | Responsable |
|---|-------------------|-----|--------------------|--------------------|----------|-------------|
| 1 | Documento PDF con evidencia | 2 | PDF consolidado con capturas, scripts, diagramas y resultados | Todos los scripts del proyecto | Todas | Luis |
| 2 | Transacciones y Control de Concurrencia | 2 | COMMIT/ROLLBACK explícitos, aislamiento READ COMMITTED y SERIALIZABLE, deadlock documentado y resuelto | `transacciones/01-06_*.sql` | Sesiones SQL completas (2 sesiones) | Wuili |
| 3 | PL/SQL, Triggers y Auditoría | 2 | Packages (pkg_inscripciones, pkg_notas), functions, triggers de auditoría y validación | `plsql/packages/*.sql`, `plsql/functions/*.sql`, `plsql/triggers/*.sql` | Ejecución y resultados | Emmanuel |
| 4 | Respaldo y Recuperación | 1 | Estrategia RMAN (completo + incremental), ARCHIVELOG habilitado, simulación de pérdida y recuperación | `backup/01-04_*.sql` | Antes/después de pérdida y recovery | Luis |
| 5 | Seguridad y Roles | 1 | CREATE USER/ROLE, GRANT/REVOKE, intento de acceso no autorizado con error ORA | `seguridad/01-03_*.sql` | Usuario conectado + error ORA-01031 | Luis |
| 6 | Optimización y Rendimiento | 2 | EXPLAIN PLAN antes/después, índices estratégicos, tiempos de respuesta comparados | `optimizacion/01-05_*.sql` | DBMS_XPLAN output + tabla comparativa | Julian |
| 7 | Data Warehouse y BI | 2 | Diagrama ER dimensional, flujo ETL, 3+ KPIs estratégicos con consultas | `dw/01-03_*.sql`, diagrama en `docs/` | Modelo estrella + resultados KPI | Julian |
| 8 | Alta Disponibilidad | 1 | Diagrama HA con standby/failover, RPO/RTO definidos | `ha/01_arquitectura_ha.md`, `ha/02_failover_simulacion.sql` | Diagrama + simulación restore | Luis |
| 9 | Dominio del tema y claridad | 2 | Guion de presentación, demo funcional, preparación para Q&A | `presentacion/` | N/A (evaluación oral) | Emmanuel |

---

## Checklist de Entrega por Criterio

| Criterio | ¿Script? | ¿Captura? | ¿Diagrama? | ¿Explicación? | Estado |
|----------|----------|-----------|------------|---------------|--------|
| Documento PDF | ✅ | ✅ | ✅ | ✅ | ⬜ Pendiente |
| Transacciones | ✅ | ✅ | Opcional | ✅ | ⬜ Pendiente |
| PL/SQL y Triggers | ✅ | ✅ | Opcional | ✅ | ⬜ Pendiente |
| Respaldo y Recuperación | ✅ | ✅ | Opcional | ✅ | ⬜ Pendiente |
| Seguridad y Roles | ✅ | ✅ | Opcional | ✅ | ⬜ Pendiente |
| Optimización | ✅ | ✅ | Opcional | ✅ | ⬜ Pendiente |
| Data Warehouse y BI | ✅ | ✅ | ✅ | ✅ | ⬜ Pendiente |
| Alta Disponibilidad | Opcional | Opcional | ✅ | ✅ | ⬜ Pendiente |
| Dominio del tema | No | No | No | ✅ | ⬜ Pendiente |

---

## Ubicación de Evidencias

Cada sprint tiene su carpeta en `/evidencias/`:
- `evidencias/sprint-0/` — Capturas de repo, ambiente Oracle, conexión
- `evidencias/sprint-1/` — Capturas de transacciones, PL/SQL, triggers
- `evidencias/sprint-2/` — Capturas de seguridad, optimización, DW
- `evidencias/sprint-3/` — Capturas de HA, presentación, PDF final
