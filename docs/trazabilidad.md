# Matriz de Trazabilidad: Criterio → Evidencia → Responsable

## Tarea: T-005 | Responsable: Luis

Esta tabla vincula cada criterio de la rúbrica con la evidencia requerida, los scripts que la generan, y el responsable de entregarla.

---

## Matriz por Criterio

| # | Criterio (Rúbrica) | Pts | Evidencia Requerida | Scripts / Archivos | Capturas | Responsable |
|---|-------------------|-----|--------------------|--------------------|----------|-------------|
| 1 | Documento PDF con evidencia | 2 | PDF consolidado con capturas, scripts, diagramas y resultados | Todos los scripts del proyecto | Todas | Luis |
| 2 | Transacciones y Control de Concurrencia | 2 | COMMIT/ROLLBACK explícitos, aislamiento READ COMMITTED y SERIALIZABLE, deadlock documentado y resuelto | `transacciones/01-06_*.sql` | Sesiones SQL completas (2 sesiones) | Wuili |
| 3 | PL/SQL, Triggers y Auditoría | 2 | Packages (pkg_inscripciones, pkg_notas), functions, triggers de auditoría y validación | `plsql/packages/*.sql`, `plsql/functions/*.sql`, `plsql/triggers/*.sql` | Ejecución y resultados | Emmanuel |
| 4 | Respaldo y Recuperación | 1 | Estrategia RMAN (completo + incremental), ARCHIVELOG habilitado, simulación de pérdida y recuperación | `backup/01-04_*.sql` | Antes/después de pérdida y recovery | Luis |
| 5 | Seguridad y Roles | 1 | CREATE USER/ROLE, GRANT/REVOKE, intento de acceso no autorizado con error ORA | `seguridad/01-03_*.sql` + `MODELO_SEGURIDAD.md` | Usuario conectado + error ORA-01031 | Luis |
| 6 | Optimización y Rendimiento | 2 | EXPLAIN PLAN antes/después, índices estratégicos, tiempos de respuesta comparados | `optimizacion/01-05_*.sql` | DBMS_XPLAN output + tabla comparativa | Julian |
| 7 | Data Warehouse y BI | 2 | Diagrama ER dimensional, flujo ETL, 3+ KPIs estratégicos con consultas | `dw/01-03_*.sql`, diagrama en `docs/` | Modelo estrella + resultados KPI | Julian |
| 8 | Alta Disponibilidad | 1 | Diagrama HA con standby/failover, RPO/RTO definidos | `ha/01_arquitectura_ha.md`, `ha/02_failover_simulacion.sql`, `ha/03_rpo_rto.md` | Diagrama + simulación restore | Luis |
| 9 | Dominio del tema y claridad | 2 | Guion de presentación, demo funcional, preparación para Q&A | `presentacion/` | N/A (evaluación oral) | Emmanuel |

---

## Detalle por Tarea (Sprint 2 - Luis)

### Seguridad

| ID | Tarea | Archivo | Estado |
|----|-------|---------|--------|
| T-029 | Definir usuarios y roles | `seguridad/01_crear_roles.sql` | ✅ |
| T-030 | Demostración GRANT/REVOKE | `seguridad/02_grant_revoke.sql` | ✅ |
| T-031 | Acceso no autorizado | `seguridad/03_acceso_no_autorizado.sql` | ✅ |
| T-032 | Documentar modelo seguridad | `seguridad/MODELO_SEGURIDAD.md` | ✅ |

### Backup y Recuperación

| ID | Tarea | Archivo | Estado |
|----|-------|---------|--------|
| T-025 | Estrategia RMAN | `backup/01_estrategia_backup.sql` | ✅ |
| T-026 | Habilitar ARCHIVELOG | `backup/02_archivelog_config.sql` | ✅ |
| T-027 | Simulación pérdida | `backup/03_simulacion_perdida.sql` | ✅ |
| T-028 | Recuperación | `backup/04_recuperacion.sql` | ✅ |

### Alta Disponibilidad

| ID | Tarea | Archivo | Estado |
|----|-------|---------|--------|
| T-045 | Arquitectura HA | `ha/01_arquitectura_ha.md` | ✅ |
| T-046 | Failover, RPO y RTO | `ha/03_rpo_rto.md` | ✅ |
| T-047 | Simulación failover | `ha/02_failover_simulacion.sql` + `evidencias/sprint-3/run_sprint3.sh` | ✅ |

---

## Checklist de Entrega por Criterio

| Criterio | ¿Script? | ¿Captura? | ¿Diagrama? | ¿Explicación? | Estado |
|----------|----------|-----------|------------|---------------|--------|
| Documento PDF | ✅ | ⬜ | ✅ | ✅ | 🔄 Falta consolidar |
| Transacciones | ✅ | ⬜ | Opcional | ✅ | 🔄 Falta capturar |
| PL/SQL y Triggers | ✅ | ⬜ | Opcional | ✅ | 🔄 Falta capturar |
| Respaldo y Recuperación | ✅ | ⬜ | Opcional | ✅ | 🔄 Falta capturar |
| Seguridad y Roles | ✅ | ⬜ | Opcional | ✅ | 🔄 Falta capturar |
| Optimización | ✅ | ⬜ | Opcional | ✅ | 🔄 Falta capturar |
| Data Warehouse y BI | ✅ | ⬜ | ✅ | ✅ | 🔄 Falta capturar |
| Alta Disponibilidad | Opcional | ⬜ | ✅ | ✅ | 🔄 Falta simular |
| Dominio del tema | No | No | No | ✅ | ⬜ Pendiente |

---

## Ubicación de Evidencias

Cada sprint tiene su carpeta en `/evidencias/`:
- `evidencias/sprint-0/` — Capturas de repo, ambiente Oracle, conexión
- `evidencias/sprint-1/` — Capturas de transacciones, PL/SQL, triggers
- `evidencias/sprint-2/` — Capturas de seguridad, backup/recovery, optimización, DW
- `evidencias/sprint-3/` — Capturas de HA, presentación, PDF final

## Referencias adicionales

- Drive del equipo: `docs/recursos_equipo.md`
- Diagrama ER: `docs/diagrama_er.md`
- Diccionario de datos: `docs/diccionario_datos.md`
- Documentación PL/SQL: `docs/plsql_documentacion.md`
- Modelo de seguridad: `seguridad/MODELO_SEGURIDAD.md`
- Arquitectura HA: `ha/01_arquitectura_ha.md`
- RPO/RTO: `ha/03_rpo_rto.md`
