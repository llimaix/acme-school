#!/bin/zsh
# ============================================================
# Renombrar capturas Sprint 3
# ============================================================

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

TAREAS=(
    "T-045"
    "T-046"
    "T-047a"
    "T-047b"
    "T-047c"
    "RESUMEN_OBJETOS"
    "RESUMEN_DATOS"
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
