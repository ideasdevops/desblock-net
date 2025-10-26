#!/bin/bash

################################################################################
# DESBLOCK-NET - Creador de USB Portable (4GB)
# Script para crear un USB portable simple con DESBLOCK-NET
# Perfecto para pendrives pequeños (4GB o más)
################################################################################

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

print_header() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║         🔓 DESBLOCK-NET PORTABLE USB CREATOR             ║"
    echo "║                                                           ║"
    echo "║              Para pendrives de 4GB o más                 ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

detect_usb() {
    print_info "Detectando dispositivos USB..."
    
    # Buscar dispositivos USB
    local usb_devices=$(lsblk -d -o NAME,SIZE,TRAN | grep "usb" | awk '{print "/dev/"$1}')
    
    if [ -z "$usb_devices" ]; then
        print_error "No se encontraron dispositivos USB"
        return 1
    fi
    
    echo ""
    print_success "Dispositivos USB encontrados:"
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,TRAN | grep -E "NAME|usb"
    echo ""
    
    return 0
}

get_mount_point() {
    local device=$1
    
    # Obtener punto de montaje
    local mount_point=$(lsblk -no MOUNTPOINT "${device}1" 2>/dev/null | head -1)
    
    if [ -z "$mount_point" ]; then
        # Intentar sin el 1
        mount_point=$(lsblk -no MOUNTPOINT "${device}" 2>/dev/null | head -1)
    fi
    
    echo "$mount_point"
}

create_portable_usb() {
    local device=$1
    local mount_point=$(get_mount_point "$device")
    
    if [ -z "$mount_point" ]; then
        print_error "El dispositivo no está montado"
        print_info "Intentando montar..."
        
        # Intentar crear punto de montaje
        local temp_mount="/tmp/desblock-usb-$$"
        mkdir -p "$temp_mount"
        
        if mount "${device}1" "$temp_mount" 2>/dev/null || mount "${device}" "$temp_mount" 2>/dev/null; then
            mount_point="$temp_mount"
            print_success "Dispositivo montado en $mount_point"
        else
            print_error "No se pudo montar el dispositivo"
            return 1
        fi
    fi
    
    print_info "Punto de montaje: $mount_point"
    
    # Verificar espacio disponible
    local available_space=$(df "$mount_point" | tail -1 | awk '{print $4}')
    local available_mb=$((available_space / 1024))
    
    print_info "Espacio disponible: ${available_mb} MB"
    
    if [ $available_mb -lt 100 ]; then
        print_error "Espacio insuficiente (mínimo 100 MB requeridos)"
        return 1
    fi
    
    # Crear estructura de directorios
    print_info "Creando estructura de directorios..."
    
    local desblock_dir="$mount_point/DESBLOCK-NET"
    mkdir -p "$desblock_dir"
    mkdir -p "$desblock_dir/logs"
    mkdir -p "$desblock_dir/docs"
    
    # Copiar archivos
    print_info "Copiando DESBLOCK-NET al USB..."
    
    cp -r "$PROJECT_DIR/src" "$desblock_dir/" 2>/dev/null || true
    cp -r "$PROJECT_DIR/config" "$desblock_dir/" 2>/dev/null || true
    cp "$PROJECT_DIR/README.md" "$desblock_dir/" 2>/dev/null || true
    cp "$PROJECT_DIR/QUICKSTART.md" "$desblock_dir/" 2>/dev/null || true
    cp "$PROJECT_DIR/LICENSE" "$desblock_dir/" 2>/dev/null || true
    
    # Copiar documentación
    cp "$PROJECT_DIR/docs/MANUAL_USUARIO.md" "$desblock_dir/docs/" 2>/dev/null || true
    cp "$PROJECT_DIR/docs/FAQ.md" "$desblock_dir/docs/" 2>/dev/null || true
    
    # Crear script de inicio
    print_info "Creando script de inicio..."
    
    cat > "$desblock_dir/EJECUTAR_GUI.sh" << 'EOF'
#!/bin/bash
# DESBLOCK-NET - Launcher

cd "$(dirname "$0")/src"

# Verificar Python
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 no está instalado"
    echo "Instala Python 3 con: sudo apt install python3 python3-tk"
    read -p "Presiona Enter para cerrar..."
    exit 1
fi

# Verificar tkinter
if ! python3 -c "import tkinter" 2>/dev/null; then
    echo "ERROR: Python Tkinter no está instalado"
    echo "Instala tkinter con: sudo apt install python3-tk"
    read -p "Presiona Enter para cerrar..."
    exit 1
fi

# Ejecutar GUI
python3 gui_app.py

EOF
    
    chmod +x "$desblock_dir/EJECUTAR_GUI.sh"
    
    # Crear script CLI
    cat > "$desblock_dir/GENERAR_CODIGO.sh" << 'EOF'
#!/bin/bash
# DESBLOCK-NET - Generador CLI

cd "$(dirname "$0")/src"

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║              🔓 DESBLOCK-NET - Generador CLI             ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Solicitar datos
echo "Año de entrega del equipo (2021/2022/2023):"
read year

echo "Hardware ID:"
read hardware_id

echo "Boot Mark:"
read boot_mark

echo ""
echo "Generando código..."
echo ""

# Generar código
python3 unlock_generator.py \
    --year "$year" \
    --hardware-id "$hardware_id" \
    --boot-mark "$boot_mark" \
    --save-log

echo ""
read -p "Presiona Enter para cerrar..."

EOF
    
    chmod +x "$desblock_dir/GENERAR_CODIGO.sh"
    
    # Crear README del USB
    cat > "$desblock_dir/LEEME.txt" << 'EOF'
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║                    🔓 DESBLOCK-NET                        ║
║                                                           ║
║        Sistema de Desbloqueo Conectar Igualdad          ║
║                    USB Portable                          ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

INSTRUCCIONES DE USO:
=====================

1. REQUISITOS:
   - Linux (Ubuntu, Mint, Debian, etc.)
   - Python 3.6 o superior
   - Python Tkinter

2. INSTALACIÓN DE DEPENDENCIAS:
   sudo apt install python3 python3-tk

3. USO CON INTERFAZ GRÁFICA:
   - Doble clic en: EJECUTAR_GUI.sh
   - O desde terminal: ./EJECUTAR_GUI.sh

4. USO DESDE LÍNEA DE COMANDOS:
   - Doble clic en: GENERAR_CODIGO.sh
   - O desde terminal: ./GENERAR_CODIGO.sh

5. DOCUMENTACIÓN:
   - Ver: README.md
   - Ver: QUICKSTART.md
   - Ver: docs/MANUAL_USUARIO.md

SOPORTE:
========
- GitHub: https://github.com/ideasdevops/desblock-net
- Documentación completa en carpeta docs/

IMPORTANTE:
===========
- Este USB es portable, funciona en cualquier Linux
- No requiere instalación
- Los códigos se generan localmente
- Conecta el equipo a Internet después de desbloquear

EOF
    
    # Crear archivo autorun para Windows (informativo)
    cat > "$desblock_dir/AUTORUN.INF" << 'EOF'
[autorun]
label=DESBLOCK-NET
icon=icon.ico
action=Abrir DESBLOCK-NET
shellexecute=LEEME.txt
EOF
    
    # Sincronizar cambios
    print_info "Sincronizando cambios..."
    sync
    
    print_success "USB portable creado exitosamente"
    
    return 0
}

show_completion() {
    local mount_point=$1
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}║         ✓ USB PORTABLE CREADO EXITOSAMENTE              ║${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    print_info "Ubicación: $mount_point/DESBLOCK-NET"
    echo ""
    print_info "CÓMO USAR:"
    echo "  1. Inserta el USB en cualquier computadora con Linux"
    echo "  2. Abre la carpeta DESBLOCK-NET"
    echo "  3. Ejecuta: EJECUTAR_GUI.sh (interfaz gráfica)"
    echo "     O ejecuta: GENERAR_CODIGO.sh (línea de comandos)"
    echo ""
    print_info "REQUISITOS:"
    echo "  - Linux (cualquier distribución)"
    echo "  - Python 3.6+"
    echo "  - sudo apt install python3 python3-tk"
    echo ""
    print_warning "Para retirar el USB de forma segura:"
    echo "  - Haz clic derecho > Expulsar"
    echo "  - O ejecuta: umount $mount_point"
    echo ""
}

main() {
    print_header
    
    # Detectar USB
    if ! detect_usb; then
        exit 1
    fi
    
    # Obtener dispositivo
    if [ -z "$1" ]; then
        print_error "Uso: $0 <dispositivo>"
        print_info "Ejemplo: $0 /dev/sda"
        print_warning "Usa el dispositivo mostrado arriba (ej: /dev/sda)"
        exit 1
    fi
    
    local device=$1
    
    # Validar dispositivo
    if [ ! -b "$device" ]; then
        print_error "El dispositivo $device no existe"
        exit 1
    fi
    
    print_info "Dispositivo seleccionado: $device"
    
    # Confirmación
    echo ""
    print_warning "Se creará DESBLOCK-NET portable en $device"
    print_info "Los archivos existentes NO se borrarán (solo se agregará DESBLOCK-NET)"
    echo -n "¿Continuar? (s/N): "
    read -r confirmation
    
    if [ "$confirmation" != "s" ] && [ "$confirmation" != "S" ]; then
        print_info "Operación cancelada"
        exit 0
    fi
    
    # Crear USB portable
    if create_portable_usb "$device"; then
        local mount_point=$(get_mount_point "$device")
        show_completion "$mount_point"
        exit 0
    else
        print_error "Error al crear USB portable"
        exit 1
    fi
}

# Ejecutar
main "$@"

