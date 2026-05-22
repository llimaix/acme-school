#!/bin/bash
# ============================================================
# ACME SCHOOL - Validación del Ambiente de Base de Datos
# Verifica que la INFRAESTRUCTURA está lista para que el
# equipo pueda trabajar en sus tareas.
# NO valida tareas del proyecto (eso va en cada carpeta).
# ============================================================

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0
WARN=0

check_pass() { echo -e "  ${GREEN}✅${NC} $1"; PASS=$((PASS+1)); }
check_fail() { echo -e "  ${RED}❌${NC} $1"; FAIL=$((FAIL+1)); }
check_warn() { echo -e "  ${YELLOW}⚠️${NC}  $1"; WARN=$((WARN+1)); }

echo "=========================================="
echo "  ACME SCHOOL - Validación de Ambiente"
echo "=========================================="
echo ""

# 1. Contenedor Oracle
echo "📦 CONTENEDOR"
if docker inspect --format="{{.State.Health.Status}}" acme-school-db 2>/dev/null | grep -q "healthy"; then
    check_pass "Oracle container healthy"
else
    check_fail "Oracle container NOT healthy"
    exit 1
fi

# 2. Conexión schema owner
echo ""
echo "🔌 CONEXIONES"
RESULT=$(docker exec acme-school-db sqlplus -s acme_school/AcmeSchool2025@FREEPDB1 <<EOF
SET HEADING OFF FEEDBACK OFF
SELECT 'OK' FROM DUAL;
EXIT;
EOF
)
if echo "$RESULT" | grep -q "OK"; then
    check_pass "acme_school (schema owner)"
else
    check_fail "acme_school NO conecta"
fi

# 3. Conexiones del equipo
for USER_INFO in "wuili:Wuili2025" "emmanuel:Emmanuel2025" "julian:Julian2025" "luis:Luis2025"; do
    USER=$(echo $USER_INFO | cut -d: -f1)
    PASS_W=$(echo $USER_INFO | cut -d: -f2)
    RESULT=$(docker exec acme-school-db sqlplus -s ${USER}/${PASS_W}@FREEPDB1 <<EOF
SET HEADING OFF FEEDBACK OFF
SELECT 'OK' FROM DUAL;
EXIT;
EOF
)
    if echo "$RESULT" | grep -q "OK"; then
        check_pass "$USER"
    else
        check_fail "$USER NO conecta"
    fi
done

# 4. Tablas del modelo
echo ""
echo "📋 TABLAS"
TABLES=$(docker exec acme-school-db sqlplus -s acme_school/AcmeSchool2025@FREEPDB1 <<EOF
SET HEADING OFF FEEDBACK OFF PAGESIZE 0
SELECT table_name FROM user_tables ORDER BY table_name;
EXIT;
EOF
)
for TBL in ESTUDIANTE DOCENTE CURSO PERIODO SECCION INSCRIPCION NOTA AUDITORIA_ACADEMICA; do
    if echo "$TABLES" | grep -q "$TBL"; then
        check_pass "$TBL"
    else
        check_fail "$TBL no existe"
    fi
done

# 5. Datos de prueba
echo ""
echo "📊 DATOS"
DATA_CHECK=$(docker exec acme-school-db sqlplus -s acme_school/AcmeSchool2025@FREEPDB1 <<EOF
SET HEADING OFF FEEDBACK OFF PAGESIZE 0
SELECT 'EST:' || COUNT(*) FROM estudiante;
SELECT 'DOC:' || COUNT(*) FROM docente;
SELECT 'SEC:' || COUNT(*) FROM seccion;
SELECT 'INS:' || COUNT(*) FROM inscripcion;
SELECT 'NOT:' || COUNT(*) FROM nota;
EXIT;
EOF
)
EST=$(echo "$DATA_CHECK" | grep "EST:" | tr -d ' ' | cut -d: -f2)
INS=$(echo "$DATA_CHECK" | grep "INS:" | tr -d ' ' | cut -d: -f2)
NOT=$(echo "$DATA_CHECK" | grep "NOT:" | tr -d ' ' | cut -d: -f2)

[ "${EST:-0}" -ge 20 ] && check_pass "Estudiantes: $EST" || check_fail "Estudiantes: ${EST:-0} (necesita ≥20)"
[ "${INS:-0}" -ge 50 ] && check_pass "Inscripciones: $INS" || check_fail "Inscripciones: ${INS:-0} (necesita ≥50)"
[ "${NOT:-0}" -ge 50 ] && check_pass "Notas: $NOT" || check_warn "Notas: ${NOT:-0} (recomendado ≥50)"

# 6. Secuencias
echo ""
echo "🔢 SECUENCIAS"
SEQ=$(docker exec acme-school-db sqlplus -s acme_school/AcmeSchool2025@FREEPDB1 <<EOF
SET HEADING OFF FEEDBACK OFF PAGESIZE 0
SELECT COUNT(*) FROM user_sequences;
EXIT;
EOF
)
SEQ_COUNT=$(echo "$SEQ" | tr -d ' ' | grep -E '^[0-9]+$' | head -1)
[ "${SEQ_COUNT:-0}" -ge 7 ] && check_pass "Secuencias: $SEQ_COUNT" || check_fail "Secuencias: ${SEQ_COUNT:-0} (necesita ≥7)"

# Resumen
echo ""
echo "=========================================="
echo "  RESUMEN"
echo "=========================================="
echo -e "  ${GREEN}Passed: $PASS${NC}"
echo -e "  ${RED}Failed: $FAIL${NC}"
echo -e "  ${YELLOW}Warnings: $WARN${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✅ Ambiente LISTO - El equipo puede trabajar${NC}"
    exit 0
else
    echo -e "${RED}❌ Hay $FAIL problemas que resolver${NC}"
    exit 1
fi
