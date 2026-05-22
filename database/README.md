# Database - Infraestructura Oracle 23ai Free

Esta carpeta contiene **solo la infraestructura** para levantar y mantener la base de datos. Las tareas del proyecto (seguridad, backup, optimización, etc.) van en sus carpetas respectivas.

## Estructura

```
database/
├── docker-compose.yml       # Contenedor Oracle 23ai Free
├── .env.example             # Variables de entorno (copiar como .env)
├── CONEXION_EQUIPO.md       # Datos de conexión para el equipo
├── init-scripts/            # Scripts que crean la BD desde cero
│   ├── 01_create_schema.sql # Tablespace, usuario owner, usuarios equipo
│   ├── 02_create_sequences.sql
│   ├── 03_create_tables.sql
│   ├── 04_insert_data.sql   # Datos maestros (docentes, cursos, etc.)
│   ├── 05_insert_inscripciones_notas.sql
│   └── 06_insert_notas.sql
└── scripts/
    ├── setup-server.sh      # Setup inicial del servidor AWS
    ├── deploy.sh            # Deploy manual
    ├── backup.sh            # Backup Data Pump manual
    ├── reset-db.sh          # Reset completo (destruye datos)
    └── validate-environment.sh  # Validar que todo está listo
```

## Qué NO va aquí

| Tarea | Carpeta correcta |
|-------|-----------------|
| Roles, GRANT/REVOKE | `/seguridad/` |
| RMAN, ARCHIVELOG, recovery | `/backup/` |
| EXPLAIN PLAN, índices | `/optimizacion/` |
| Modelo dimensional, ETL | `/dw/` |
| Triggers, packages | `/plsql/` |
| Transacciones, deadlock | `/transacciones/` |
| Alta disponibilidad | `/ha/` |

## Comandos

```bash
# Levantar Oracle
docker compose up -d

# Ver logs
docker logs -f acme-school-db

# Conectarse
docker exec -it acme-school-db sqlplus acme_school/AcmeSchool2025@FREEPDB1

# Validar ambiente
chmod +x scripts/validate-environment.sh
./scripts/validate-environment.sh

# Reset completo
chmod +x scripts/reset-db.sh
./scripts/reset-db.sh
```

## GitHub Action

El workflow `.github/workflows/deploy-database.yml` se dispara cuando hay cambios en `database/**` y:
1. Copia archivos al servidor AWS
2. Levanta Oracle si no está corriendo
3. Ejecuta init-scripts en orden
4. Verifica que las tablas y datos existen
