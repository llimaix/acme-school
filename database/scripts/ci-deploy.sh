#!/bin/bash
# ============================================================
# ACME SCHOOL - Script de deploy para CI/CD
# Se ejecuta en el servidor después de copiar los archivos
# ============================================================

set -e

PROJECT_DIR="/opt/acme-school/database"
cd "$PROJECT_DIR"

echo "=== 1. Verificando Docker ==="
docker --version
docker compose version

echo "=== 2. Levantando Oracle ==="
docker compose up -d

echo "=== 3. Esperando que Oracle esté healthy ==="
ATTEMPTS=0
MAX_ATTEMPTS=30
until docker inspect --format='{{.State.Health.Status}}' acme-school-db 2>/dev/null | grep -q "healthy"; do
    ATTEMPTS=$((ATTEMPTS + 1))
    if [ $ATTEMPTS -ge $MAX_ATTEMPTS ]; then
        echo "ERROR: Oracle no arrancó después de $MAX_ATTEMPTS intentos"
        docker logs --tail 50 acme-school-db
        exit 1
    fi
    echo "  Esperando Oracle... (intento $ATTEMPTS/$MAX_ATTEMPTS)"
    sleep 10
done
echo "Oracle está listo."

echo "=== 4. Backup pre-deploy ==="
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
docker exec acme-school-db bash -c \
  "expdp system/AcmeSchool2025@FREEPDB1 DIRECTORY=DATA_PUMP_DIR DUMPFILE=pre_deploy_${TIMESTAMP}.dmp LOGFILE=pre_deploy_${TIMESTAMP}.log SCHEMAS=acme_school 2>/dev/null" \
  || echo "  Backup skipped (schema may not exist yet)"

echo "=== 5. Copiando scripts al contenedor ==="
docker cp ./init-scripts/. acme-school-db:/opt/oracle/scripts/

echo "=== 6. Script 01 - Schema (como SYSTEM) ==="
docker exec acme-school-db bash -c "echo '@/opt/oracle/scripts/01_create_schema.sql
EXIT;' | sqlplus -s system/AcmeSchool2025@FREEPDB1" || echo "  Schema ya puede existir, continuando..."

echo "=== 7. Scripts 02+ (como acme_school) ==="
for script in ./init-scripts/0[2-9]_*.sql; do
    if [ -f "$script" ]; then
        BASENAME=$(basename "$script")
        echo "  >> $BASENAME"
        docker exec acme-school-db bash -c "echo '@/opt/oracle/scripts/$BASENAME
EXIT;' | sqlplus -s acme_school/AcmeSchool2025@FREEPDB1" || echo "  WARN: $BASENAME tuvo errores (objetos pueden ya existir)"
    fi
done

echo "=== 8. Verificación final ==="
docker exec acme-school-db bash -c "echo '
SET LINESIZE 200
SET PAGESIZE 50
COLUMN table_name FORMAT A25

SELECT table_name FROM user_tables ORDER BY table_name;

SELECT (SELECT COUNT(*) FROM estudiante) AS estudiantes,
       (SELECT COUNT(*) FROM docente) AS docentes,
       (SELECT COUNT(*) FROM curso) AS cursos,
       (SELECT COUNT(*) FROM periodo) AS periodos,
       (SELECT COUNT(*) FROM seccion) AS secciones,
       (SELECT COUNT(*) FROM inscripcion) AS inscripciones,
       (SELECT COUNT(*) FROM nota) AS notas
FROM DUAL;

SELECT object_name, object_type, status FROM user_objects WHERE status != chr(86)||chr(65)||chr(76)||chr(73)||chr(68);
EXIT;' | sqlplus -s acme_school/AcmeSchool2025@FREEPDB1"

echo ""
echo "=== Deploy completado ==="
