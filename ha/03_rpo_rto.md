# Failover, RPO y RTO

## Tarea: T-046 | Responsable: Luis

## Definiciones

| Métrica | Significado | Pregunta que responde |
|---------|-------------|----------------------|
| **RPO** (Recovery Point Objective) | Cantidad máxima de datos que se puede perder | "¿Cuánto trabajo perdemos si cae el sistema?" |
| **RTO** (Recovery Time Objective) | Tiempo máximo aceptable para restaurar el servicio | "¿Cuánto puede estar caído el sistema?" |

## RPO y RTO definidos para ACME School

| Escenario | RPO objetivo | RTO objetivo |
|-----------|--------------|--------------|
| Pérdida menor (registro corrupto) | 0 (Flashback) | < 1 minuto |
| Pérdida media (tabla o schema) | < 15 min | < 15 minutos |
| Caída del primario | < 1 hora | < 30 minutos |
| Pérdida total del data center | < 6 horas | < 4 horas |

## Capacidad real con la arquitectura actual

### Edición Free + ARCHIVELOG (sin Data Guard)

| Métrica | Valor real | Cómo se logra |
|---------|-----------|----------------|
| **RPO** | ~ último archive log switch | Modo ARCHIVELOG con RMAN incremental |
| **RTO** | 5 - 30 minutos | Restore desde último backup completo + replay de archivelogs |

### Con Data Guard async (referencia para producción)

| Métrica | Valor | Cómo se logra |
|---------|-------|----------------|
| **RPO** | Segundos | Apply de redo logs casi en tiempo real |
| **RTO** | < 1 minuto | Failover automático con Observer |

### Con Data Guard sync (máxima protección)

| Métrica | Valor | Cómo se logra |
|---------|-------|----------------|
| **RPO** | 0 | Cada commit en primario espera ack del standby |
| **RTO** | < 30 segundos | Failover automático |

## Proceso de Failover (paso a paso)

### 1. Detección
- Monitoreo activo cada 30 segundos al puerto 1521
- Si 3 chequeos consecutivos fallan → declarar caída
- Alarmas a equipo de ops

### 2. Decisión
- **Caída transitoria**: esperar 5 minutos antes de failover
- **Caída prolongada**: ejecutar failover manual o automático

### 3. Promoción del standby
```bash
# En la simulación con Docker:
docker stop acme-school-db                  # confirmar caída del primario
# El standby (acme-school-standby) ya está corriendo en puerto 1522
# Se vuelve el "nuevo primario"
```

En Data Guard real:
```sql
-- Conectado al standby como SYSDBA:
ALTER DATABASE COMMIT TO SWITCHOVER TO PRIMARY;
ALTER DATABASE OPEN;
```

### 4. Redirección de aplicación
- DNS interno apunta al nuevo primario
- App reconecta automáticamente (gracias a `failover=on` en connection string)
- Validar que las operaciones funcionan

### 5. Reconstrucción del antiguo primario
- Una vez resuelto el problema original
- Se rebuilda como nuevo standby (recibe redo logs del nuevo primario)

## Métricas medidas en la simulación (T-047)

A completar después de ejecutar la demo:

| Paso | Tiempo medido |
|------|---------------|
| Detección de caída | _a medir_ |
| Promoción de standby | _a medir_ |
| Verificación de datos | _a medir_ |
| Reconexión de app | _a medir_ |
| **Total RTO** | _a medir_ |
| **RPO observado** | _a medir_ |

## Pruebas de Disaster Recovery

Agenda recomendada en producción:

| Frecuencia | Prueba |
|------------|--------|
| Mensual | Restore de backup en ambiente de prueba |
| Trimestral | Switchover programado primary ↔ standby |
| Semestral | Failover simulado con caída forzada |
| Anual | DR completo en sitio alterno |

## Decisiones de tradeoff

### Async vs Sync replication
**Elegido: Async**

- Pros: menor latencia en commits del primario, resiliente a problemas de red entre sitios
- Contras: RPO > 0 (segundos a minutos)
- Justificación: para un sistema académico, perder unos segundos de datos es aceptable. Para banca sería distinto.

### Failover automático vs manual
**Elegido: Manual con observer**

- Pros: evita falsos positivos (split-brain)
- Contras: agrega latencia humana al RTO
- Justificación: el costo de un failover incorrecto (split-brain) es mayor que el de unos minutos extra de downtime.

### Backups locales + offsite
**Elegido: Ambos**

- Local (RMAN): rápido para restore frecuente
- Offsite (S3): protección ante desastre del data center

## Referencias

- Implementación práctica: `ha/02_failover_simulacion.sql`
- Estrategia de backup: `backup/01_estrategia_backup.sql`
- Configuración ARCHIVELOG: `backup/02_archivelog_config.sql`
