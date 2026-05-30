# Infraestructura de Base de Datos

Levanta Oracle 23ai Free en Docker. Las credenciales se leen de un `.env`
en el servidor (no versionado).

## Estructura

```
database/
├── docker-compose.yml   # Contenedor Oracle
├── .env                 # Credenciales (no versionado)
└── scripts/
    └── ci-deploy.sh     # Script que ejecuta el GitHub Action
```

## Características

- Oracle 23ai Free en contenedor `acme-school-db`
- Volúmenes persistentes para datos y backups
- Healthcheck y reinicio automático

## Variables de entorno (`.env`)

```
ORACLE_PASSWORD=...        # Password de SYS y SYSTEM
APP_USER=...               # Usuario adicional de aplicación
APP_USER_PASSWORD=...
```

## Comandos

```bash
docker compose up -d                                              # Levantar
docker inspect --format='{{.State.Health.Status}}' acme-school-db # Estado
docker exec -it acme-school-db sqlplus system/<pass>@FREEPDB1     # Conectar
docker logs -f acme-school-db                                     # Logs
```

## Despliegue automático

El workflow `.github/workflows/deploy-database.yml` se dispara con cambios en
`database/**` o de forma manual: copia los archivos al servidor y ejecuta
`ci-deploy.sh`, que levanta Oracle y verifica que esté healthy.
