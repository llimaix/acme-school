# Alta Disponibilidad - Arquitectura

## Responsable: Luis
## Tareas: T-045, T-046

## Diagrama HA (por crear)

Componentes del diagrama:
- Oracle Primary (producción)
- Oracle Standby/Replica (conceptual o simulado)
- Backups RMAN
- Proceso de failover
- Capa de aplicación (Node.js/API)
- Frontend (React)
- Usuarios finales

## RPO y RTO

- **RPO (Recovery Point Objective):** Máxima pérdida de datos aceptable
  - Con ARCHIVELOG: RPO ≈ último archived redo log
  - Con Data Guard (si aplica): RPO ≈ 0 (síncrono)

- **RTO (Recovery Time Objective):** Tiempo máximo para restaurar servicio
  - Con restore RMAN: RTO ≈ minutos a horas según tamaño
  - Con failover automático: RTO ≈ segundos

## Proceso de Failover

1. Detección de caída del primario
2. Promoción del standby a primario
3. Redirección de conexiones
4. Verificación de integridad
5. Reconstrucción del standby original

## Nota Importante

Si la edición gratuita (Oracle Free/XE) limita Data Guard:
- Presentar como DISEÑO conceptual
- Simular failover con restore en instancia secundaria
- NO afirmar implementación real si no se prueba
