#!/bin/sh

# Salir si ocurre un error inesperado
set -e

# Detectar la pantalla actual
DISPLAY_TARGET="${DISPLAY:-:0}"

# Detectar la resolución real del servidor X
RESOLUTION=""

if command -v xwininfo >/dev/null 2>&1; then
    RESOLUTION=$(xwininfo -root 2>/dev/null | awk '/-geometry/ {print $2}' | cut -d'+' -f1)
fi

if [ -z "$RESOLUTION" ] && command -v xdpyinfo >/dev/null 2>&1; then
    RESOLUTION=$(xdpyinfo 2>/dev/null | awk '/dimensions:/ {print $2}')
fi

if [ -z "$RESOLUTION" ] && command -v xrandr >/dev/null 2>&1; then
    RESOLUTION=$(xrandr 2>/dev/null | grep -w "connected" | grep -oE '[0-9]+x[0-9]+' | head -n1)
fi

# Fallback si no se detectó nada
RESOLUTION="${RESOLUTION:-1600x900}"

# Nombre del archivo de salida
OUTPUT="${1:-grabacion_$(date +'%Y-%m-%d_%H-%M-%S').mp4}"

echo "=========================================="
echo " [*] Iniciando grabacion de pantalla"
echo " [*] Display    : $DISPLAY_TARGET"
echo " [*] Resolucion : $RESOLUTION"
echo " [*] Archivo    : $OUTPUT"
echo " [*] Detener    : Presiona 'q' o Ctrl+C"
echo "=========================================="

# Comando ffmpeg
ffmpeg \
    -hide_banner -loglevel warning -stats \
    -f x11grab \
    -framerate 30 \
    -video_size "$RESOLUTION" \
    -i :0.0 \
    -c:v libx264 -preset ultrafast -pix_fmt yuv420p \
    "$OUTPUT"

echo ""
echo "[+] Grabacion guardada en: $OUTPUT"

