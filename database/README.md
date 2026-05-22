# Database - Infraestructura Oracle

Solo levanta Oracle 23ai Free con Docker. Nada más.

## Estructura

```
database/
├── docker-compose.yml   # Contenedor Oracle
├── scripts/
│   └── ci-deploy.sh     # Lo que ejecuta el GitHub Action
└── README.md
```

## Qué hace

- Levanta Oracle 23ai Free en Docker
- Volumen persistente para datos (`oracle-data`)
- Volumen persistente para backups (`oracle-backups`)
- Healthcheck automático
- Restart automático si se cae

## Conexión

| Parámetro | Valor |
|-----------|-------|
| Host | IP del servidor |
| Port | 1521 |
| Service | FREEPDB1 |
| User | system |
| Password | AcmeSchool2025 |

## Comandos

```bash
# Levantar
docker compose up -d

# Ver estado
docker inspect --format='{{.State.Health.Status}}' acme-school-db

# Conectarse
docker exec -it acme-school-db sqlplus system/AcmeSchool2025@FREEPDB1

# Ver logs
docker logs -f acme-school-db
```

## GitHub Action

Se dispara con cambios en `database/**` o manualmente. Solo levanta Oracle y verifica que esté healthy.
