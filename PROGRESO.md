# Progreso del Proyecto - ACME School

## Equipo
| Miembro | Rol Principal |
|---------|---------------|
| Wuili | Modelo operacional, Transacciones y Concurrencia |
| Emmanuel | PL/SQL, Triggers, Auditoría, Presentación |
| Julian | Optimización, Data Warehouse y BI |
| Luis | Documento PDF, Seguridad, Backup, HA |

---

## Sprint 0 - Preparación (Día 1-2)

| ID | Tarea | Responsable | Estado |
|----|-------|-------------|--------|
| T-001 | Confirmar alcance del sistema | Luis | ✅ Completada |
| T-002 | Definir Oracle PL/SQL como motor | Luis | ✅ Completada |
| T-003 | Crear repositorio y estructura | Wuili | ✅ Completada |
| T-004 | Levantar ambiente Oracle Free/XE | Wuili | ✅ Completada |
| T-005 | Crear matriz de trazabilidad | Luis | ✅ Completada |

---

## Sprint 1 - Base Oracle/PL/SQL (Semana 1-2)

### Modelo Operacional
| ID | Tarea | Responsable | Estado |
|----|-------|-------------|--------|
| T-006 | Diseñar diagrama ER operacional | Wuili | ⬜ No iniciada |
| T-007 | Diccionario de datos y reglas | Emmanuel | ⬜ No iniciada |
| T-008 | Scripts DDL (tablas, secuencias, constraints) | Wuili | ⬜ No iniciada |
| T-009 | Dataset académico de pruebas | Julian | ⬜ No iniciada |
| T-010 | Probar integridad referencial | Emmanuel | ⬜ No iniciada |

### Transacciones y Concurrencia (Wuili)
| ID | Tarea | Responsable | Estado |
|----|-------|-------------|--------|
| T-011 | Package pkg_inscripciones | Emmanuel | ⬜ No iniciada |
| T-012 | COMMIT exitoso | Wuili | ⬜ No iniciada |
| T-013 | ROLLBACK ante error | Wuili | ⬜ No iniciada |
| T-014 | READ COMMITTED (2 sesiones) | Wuili | ⬜ No iniciada |
| T-015 | SERIALIZABLE (2 sesiones) | Wuili | ⬜ No iniciada |
| T-016 | Deadlock ORA-00060 | Wuili | ⬜ No iniciada |
| T-017 | Resolver deadlock | Wuili | ⬜ No iniciada |

### PL/SQL y Triggers (Emmanuel)
| ID | Tarea | Responsable | Estado |
|----|-------|-------------|--------|
| T-018 | Package pkg_notas | Emmanuel | ⬜ No iniciada |
| T-019 | Funciones PL/SQL de apoyo | Emmanuel | ⬜ No iniciada |
| T-020 | Tabla de auditoría | Emmanuel | ⬜ No iniciada |
| T-021 | Trigger de auditoría | Emmanuel | ⬜ No iniciada |
| T-022 | Trigger de validación | Emmanuel | ⬜ No iniciada |
| T-023 | Manejo de excepciones | Emmanuel | ⬜ No iniciada |
| T-024 | Documentar PL/SQL | Emmanuel | ⬜ No iniciada |

---

## Sprint 2 - Seguridad/Rendimiento/DW (Semana 2-3)

### Backup y Recuperación (Luis)
| ID | Tarea | Responsable | Estado |
|----|-------|-------------|--------|
| T-025 | Estrategia de backup RMAN | Luis | ⬜ No iniciada |
| T-026 | Configurar ARCHIVELOG | Luis | ⬜ No iniciada |
| T-027 | Simular pérdida de datos | Luis | ⬜ No iniciada |
| T-028 | Recuperar desde backup/log | Luis | ⬜ No iniciada |

### Seguridad (Luis)
| ID | Tarea | Responsable | Estado |
|----|-------|-------------|--------|
| T-029 | Definir usuarios y roles | Luis | ⬜ No iniciada |
| T-030 | GRANT y REVOKE | Luis | ⬜ No iniciada |
| T-031 | Acceso no autorizado | Luis | ⬜ No iniciada |
| T-032 | Documentar seguridad | Luis | ⬜ No iniciada |

### Optimización (Julian)
| ID | Tarea | Responsable | Estado |
|----|-------|-------------|--------|
| T-033 | Consultas críticas | Julian | ⬜ No iniciada |
| T-034 | EXPLAIN PLAN antes | Julian | ⬜ No iniciada |
| T-035 | Tiempos antes | Julian | ⬜ No iniciada |
| T-036 | Crear índices | Julian | ⬜ No iniciada |
| T-037 | EXPLAIN PLAN después | Julian | ⬜ No iniciada |
| T-038 | Reescritura SQL | Julian | ⬜ No iniciada |

### Data Warehouse (Julian)
| ID | Tarea | Responsable | Estado |
|----|-------|-------------|--------|
| T-039 | Modelo dimensional | Julian | ⬜ No iniciada |
| T-040 | DDL del DW | Julian | ⬜ No iniciada |
| T-041 | ETL operacional → DW | Julian | ⬜ No iniciada |
| T-042 | 3+ KPIs estratégicos | Julian | ⬜ No iniciada |
| T-043 | Vistas/consultas BI | Julian | ⬜ No iniciada |
| T-044 | Diagrama flujo ETL | Emmanuel | ⬜ No iniciada |

---

## Sprint 3 - Evidencia/Presentación (Semana 3)

| ID | Tarea | Responsable | Estado |
|----|-------|-------------|--------|
| T-045 | Arquitectura HA | Luis | ⬜ No iniciada |
| T-046 | Failover, RPO y RTO | Luis | ⬜ No iniciada |
| T-047 | Simulación failover | Wuili | ⬜ No iniciada |
| T-048 | API Node.js (opcional) | Emmanuel | ⬜ No iniciada |
| T-049 | Frontend React (opcional) | Emmanuel | ⬜ No iniciada |
| T-050 | PDF final consolidado | Luis | ⬜ No iniciada |

---

## Leyenda
- ⬜ No iniciada
- 🔄 En progreso
- ✅ Completada
- 🚫 Bloqueada
