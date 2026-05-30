#!/bin/zsh
# ============================================================
# Renombrar capturas Sprint 2
# ============================================================

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

TAREAS=(
    "T-029"
    "T-030"
    "T-031a"
    "T-031b"
    "T-031c"
    "T-025"
    "T-026"
    "T-027"
    "T-028"
    "T-033"
    "T-034"
    "T-036"
    "T-037"
    "T-039"
    "T-041"
    "T-042"
)

CAPTURAS=("Captura de pantalla"*.png(N))

if [ ${#CAPTURAS[@]} -eq 0 ]; then
    echo "No se encontraron capturas en esta carpeta."
    exit 1
fi

echo "Capturas encontradas: ${#CAPTURAS[@]}"
echo "Tareas a asignar: ${#TAREAS[@]}"
echo ""

COUNT=1
for CAPTURA in "${CAPTURAS[@]}"; do
    if [ $COUNT -gt ${#TAREAS[@]} ]; then
        echo "⚠️  Sobrante: $CAPTURA"
        continue
    fi
    NUEVO="${TAREAS[$COUNT]}.png"
    echo "  $CAPTURA → $NUEVO"
    mv "$CAPTURA" "$NUEVO"
    COUNT=$((COUNT + 1))
done

echo ""
echo "✅ $((COUNT - 1)) capturas renombradas"
