#!/bin/bash

################################################################################
# DESBLOCK-NET - Ejecutar Creación de USB
# Script auxiliar para facilitar la ejecución
################################################################################

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║         🔓 DESBLOCK-NET - CREAR USB BOOTEABLE            ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Este script creará un USB booteable con:"
echo "  • Linux Mint 22 Cinnamon"
echo "  • DESBLOCK-NET preinstalado"
echo ""
echo "Dispositivo: /dev/sda (1.9TB)"
echo ""
echo "⚠️  ADVERTENCIA: Se borrará todo el contenido de /dev/sda"
echo ""

read -p "¿Deseas continuar? (escribe SI en mayúsculas): " confirm

if [ "$confirm" != "SI" ]; then
    echo "Operación cancelada."
    exit 0
fi

echo ""
echo "Iniciando creación de USB booteable..."
echo "Te pedirá la contraseña de sudo..."
echo ""

sudo bash "$SCRIPT_DIR/scripts/create_bootable_usb.sh" /dev/sda

echo ""
echo "¡Proceso completado!"
read -p "Presiona Enter para cerrar..."

