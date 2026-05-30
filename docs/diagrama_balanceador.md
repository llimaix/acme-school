# Diagrama del Balanceador de Carga (HAProxy)

## Arquitectura

```mermaid
flowchart LR
    CLIENT[("Aplicación / SQL Developer<br/>Puerto 1523")]

    subgraph HAPROXY["HAProxy (acme-school-lb)"]
        LB{{Balanceador TCP<br/>puerto 1523}}
    end

    subgraph PRIMARY["Oracle Primary"]
        DB1[("acme-school-db<br/>1521 → 1521")]
    end

    subgraph STANDBY["Oracle Standby"]
        DB2[("acme-school-standby<br/>1522 → 1521")]
    end

    CLIENT --> LB
    LB -->|activo| DB1
    LB -.->|failover automático<br/>si primary cae| DB2

    classDef lb fill:#f9a825,stroke:#f57f17,color:#000
    classDef primary fill:#5b9bd5,stroke:#2e75b6,color:#fff
    classDef standby fill:#a9d18e,stroke:#548235,color:#000

    class LB lb
    class DB1 primary
    class DB2 standby
```

## Puertos

| Servicio | Puerto externo | Puerto interno | Rol |
|----------|---------------|----------------|-----|
| `acme-school-db` | 1521 | 1521 | Primary (activo) |
| `acme-school-standby` | 1522 | 1521 | Standby (backup) |
| `acme-school-lb` (HAProxy) | 1523 | 1523 | Balanceador TCP |

## Comportamiento

- La aplicación se conecta al **puerto 1523** (HAProxy).
- HAProxy enruta todo el tráfico al **primary** (1521).
- Si el primary no responde tras 3 health checks fallidos (15s), HAProxy
  redirige automáticamente al **standby** (1522).
- Cuando el primary vuelve a estar healthy, HAProxy lo reactiva como destino
  principal.

## Conexión vía balanceador

```
Host: IP_SERVIDOR
Port: 1523
Service: FREEPDB1
User: acme_school
Password: AcmeSchool2025
```

## Levantar

```bash
cd database
docker compose up -d
```

Los tres contenedores arrancan: primary, standby y HAProxy.
