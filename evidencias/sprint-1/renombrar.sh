#!/bin/bash
# ============================================================
# Renombrar capturas de pantalla en orden de tarea
# Las capturas de Mac se guardan como:
#   "Captura de pantalla 2026-05-29 a las 23.15.46.png"
# Este script las renombra en orden cronológico a:
#   T-008a.png, T-008b.png, T-009.png, etc.
# ============================================================

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# Orden de tareas para Sprint 1
TAREAS=(
    "T-008a"
    "T-008b"
    "T-009"
    "T-010"
    "T-011"
    "T-018"
    "T-019"
    "T-021"
    "T-022"
    "T-012"
    "T-013"
    "T-014"
    "T-015"
    "T-016"
    "T-017"
)

# Buscar capturas ordenadas por fecha (nombre contiene timestamp)
mapfile -t CAPTURAS < <(ls "Captura de pantalla"*.png 2>/dev/null | sort)

if [ ${#CAPTURAS[@]} -eq 0 ]; then
    echo "No se encontraron capturas de pantalla en esta carpeta."
    echo "Copia las capturas aquí primero."
    exit 1
fi

echo "Capturas encontradas: ${#CAPTURAS[@]}"
echo "Tareas a asignar: ${#TAREAS[@]}"
echo ""

# Renombrar en orden
COUNT=0
for CAPTURA in "${CAPTURAS[@]}"; do
    if [ $COUNT -ge ${#TAREAS[@]} ]; then
        echo "⚠️  Más capturas que tareas. Sobrante: $CAPTURA"
        continue
    fi
    
    NUEVO="${TAREAS[$COUNT]}.png"
    echo "  $CAPTURA → $NUEVO"
    mv "$CAPTURA" "$NUEVO"
    COUNT=$((COUNT + 1))
done

echo ""
echo "✅ $COUNT capturas renombradas"

if [ $COUNT -lt ${#TAREAS[@]} ]; then
    echo "⚠️  Faltan capturas para: ${TAREAS[@]:$COUNT}"
fi
