#!/bin/bash

################################################################################
# DESBLOCK-NET - Creador de USB Booteable
# Script para crear un USB booteable con Linux Mint y DESBLOCK-NET
################################################################################

set -e  # Salir si hay errores

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ISO_URL="https://mirrors.edge.kernel.org/linuxmint/stable/22/linuxmint-22-cinnamon-64bit.iso"
ISO_NAME="linuxmint-22-cinnamon-64bit.iso"
DOWNLOAD_DIR="$HOME/desblock-net-downloads"
MIN_USB_SIZE=$((7 * 1024 * 1024 * 1024))  # 7 GB en bytes

################################################################################
# Funciones
################################################################################

print_header() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║              🔓 DESBLOCK-NET USB CREATOR                 ║"
    echo "║                                                           ║"
    echo "║        Creador de USB Booteable con Linux Mint          ║"
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

check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "Este script debe ejecutarse como root (sudo)"
        exit 1
    fi
}

check_dependencies() {
    print_info "Verificando dependencias..."
    
    local deps=("wget" "dd" "lsblk" "parted" "mkfs.vfat")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        print_error "Faltan las siguientes dependencias: ${missing[*]}"
        print_info "Instálelas con: sudo apt install ${missing[*]}"
        exit 1
    fi
    
    print_success "Todas las dependencias están instaladas"
}

list_usb_devices() {
    print_info "Dispositivos USB disponibles:"
    echo ""
    
    lsblk -d -o NAME,SIZE,TYPE,TRAN | grep "usb" | while read line; do
        echo "  $line"
    done
    
    echo ""
}

validate_device() {
    local device=$1
    
    # Verificar que el dispositivo existe
    if [ ! -b "$device" ]; then
        print_error "El dispositivo $device no existe"
        return 1
    fi
    
    # Verificar que es un dispositivo USB
    local device_name=$(basename "$device")
    local removable_file="/sys/block/$device_name/removable"
    
    if [ -f "$removable_file" ]; then
        local is_removable=$(cat "$removable_file")
        if [ "$is_removable" != "1" ]; then
            print_error "$device no parece ser un dispositivo USB removible"
            return 1
        fi
    fi
    
    # Verificar tamaño del dispositivo
    local size_bytes=$(blockdev --getsize64 "$device")
    if [ "$size_bytes" -lt "$MIN_USB_SIZE" ]; then
        print_error "El dispositivo es muy pequeño (mínimo 7 GB requeridos)"
        return 1
    fi
    
    return 0
}

download_iso() {
    local iso_path="$DOWNLOAD_DIR/$ISO_NAME"
    
    # Crear directorio de descargas
    mkdir -p "$DOWNLOAD_DIR"
    
    # Verificar si ya existe la ISO
    if [ -f "$iso_path" ]; then
        print_info "ISO encontrada: $iso_path"
        
        # Verificar integridad básica
        local size=$(stat -f%z "$iso_path" 2>/dev/null || stat -c%s "$iso_path" 2>/dev/null)
        if [ "$size" -gt $((2 * 1024 * 1024 * 1024)) ]; then
            print_success "ISO válida encontrada"
            echo "$iso_path"
            return 0
        else
            print_warning "ISO corrupta o incompleta, descargando nuevamente..."
            rm -f "$iso_path"
        fi
    fi
    
    # Descargar ISO
    print_info "Descargando Linux Mint ISO..."
    print_info "URL: $ISO_URL"
    print_warning "Esto puede tardar varios minutos dependiendo de su conexión"
    
    if wget --progress=bar:force -O "$iso_path" "$ISO_URL"; then
        print_success "ISO descargada exitosamente"
        echo "$iso_path"
        return 0
    else
        print_error "Error al descargar la ISO"
        rm -f "$iso_path"
        return 1
    fi
}

unmount_device() {
    local device=$1
    
    print_info "Desmontando particiones de $device..."
    
    # Desmontar todas las particiones del dispositivo
    for partition in ${device}*; do
        if [ "$partition" != "$device" ]; then
            if mount | grep -q "$partition"; then
                umount "$partition" 2>/dev/null || true
            fi
        fi
    done
    
    print_success "Particiones desmontadas"
}

create_bootable_usb() {
    local iso_path=$1
    local device=$2
    
    print_info "Creando USB booteable..."
    print_warning "TODOS LOS DATOS EN $device SERÁN BORRADOS"
    print_warning "Presione Ctrl+C en los próximos 5 segundos para cancelar"
    sleep 5
    
    # Desmontar dispositivo
    unmount_device "$device"
    
    # Escribir ISO al USB usando dd
    print_info "Escribiendo imagen al USB (esto puede tardar varios minutos)..."
    
    if dd if="$iso_path" of="$device" bs=4M status=progress oflag=sync; then
        sync
        print_success "Imagen escrita exitosamente"
        return 0
    else
        print_error "Error al escribir la imagen"
        return 1
    fi
}

customize_usb() {
    local device=$1
    
    print_info "Personalizando USB con DESBLOCK-NET..."
    
    # Esperar a que el kernel reconozca las nuevas particiones
    sleep 3
    partprobe "$device" 2>/dev/null || true
    sleep 2
    
    # Intentar montar la partición del USB
    local mount_point="/tmp/desblock-usb-mount"
    mkdir -p "$mount_point"
    
    # Buscar la partición con el sistema de archivos
    local partition=""
    for part in ${device}*; do
        if [ "$part" != "$device" ]; then
            # Intentar montar
            if mount "$part" "$mount_point" 2>/dev/null; then
                partition="$part"
                break
            fi
        fi
    done
    
    if [ -z "$partition" ]; then
        print_warning "No se pudo personalizar el USB automáticamente"
        print_info "El USB booteable básico está listo"
        return 0
    fi
    
    print_info "USB montado en $mount_point"
    
    # Copiar archivos de DESBLOCK-NET
    print_info "Copiando archivos de DESBLOCK-NET..."
    
    local desblock_dir="$mount_point/desblock-net"
    mkdir -p "$desblock_dir"
    
    # Copiar el código fuente
    cp -r "$PROJECT_DIR/src" "$desblock_dir/" 2>/dev/null || true
    cp -r "$PROJECT_DIR/config" "$desblock_dir/" 2>/dev/null || true
    cp "$PROJECT_DIR/README.md" "$desblock_dir/" 2>/dev/null || true
    
    # Crear script de inicio automático
    cat > "$desblock_dir/run.sh" << 'EOF'
#!/bin/bash
# Script de inicio DESBLOCK-NET

cd "$(dirname "$0")/src"

# Verificar Python
if ! command -v python3 &> /dev/null; then
    zenity --error --text="Python 3 no está instalado" --title="DESBLOCK-NET Error"
    exit 1
fi

# Ejecutar GUI
python3 gui_app.py
EOF
    
    chmod +x "$desblock_dir/run.sh"
    
    # Crear acceso directo en el escritorio (si existe)
    if [ -d "$mount_point/home" ]; then
        local desktop_dirs=$(find "$mount_point/home" -maxdepth 2 -type d -name "Desktop" -o -name "Escritorio")
        
        for desktop_dir in $desktop_dirs; do
            cat > "$desktop_dir/DESBLOCK-NET.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=DESBLOCK-NET
Comment=Sistema de Desbloqueo Conectar Igualdad
Exec=/media/desblock-net/run.sh
Icon=utilities-terminal
Terminal=false
Categories=Utility;System;
EOF
            chmod +x "$desktop_dir/DESBLOCK-NET.desktop"
        done
    fi
    
    sync
    umount "$mount_point"
    rmdir "$mount_point"
    
    print_success "USB personalizado con DESBLOCK-NET"
}

show_completion() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}║              ✓ USB BOOTEABLE CREADO EXITOSAMENTE         ║${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    print_info "Pasos siguientes:"
    echo "  1. Retire el USB de forma segura"
    echo "  2. Inserte el USB en el equipo bloqueado"
    echo "  3. Reinicie y presione F12/F10/ESC para boot menu"
    echo "  4. Seleccione el USB como dispositivo de arranque"
    echo "  5. Ejecute DESBLOCK-NET desde el escritorio"
    echo ""
}

################################################################################
# Main
################################################################################

main() {
    print_header
    
    # Verificar root
    check_root
    
    # Verificar dependencias
    check_dependencies
    
    # Obtener dispositivo USB
    if [ -z "$1" ]; then
        list_usb_devices
        print_error "Uso: $0 <dispositivo>"
        print_info "Ejemplo: $0 /dev/sdb"
        print_warning "⚠️  ADVERTENCIA: Todos los datos en el dispositivo serán borrados"
        exit 1
    fi
    
    local device=$1
    
    # Validar dispositivo
    if ! validate_device "$device"; then
        exit 1
    fi
    
    print_info "Dispositivo seleccionado: $device"
    local size=$(blockdev --getsize64 "$device" | awk '{printf "%.1f GB", $1/1024/1024/1024}')
    print_info "Tamaño: $size"
    
    # Confirmación final
    echo ""
    print_warning "⚠️  ADVERTENCIA FINAL ⚠️"
    print_warning "Todos los datos en $device serán PERMANENTEMENTE BORRADOS"
    echo -n "¿Está seguro que desea continuar? (escriba 'SI' para confirmar): "
    read -r confirmation
    
    if [ "$confirmation" != "SI" ]; then
        print_info "Operación cancelada"
        exit 0
    fi
    
    # Descargar ISO
    print_info "Paso 1/3: Descargando Linux Mint ISO..."
    iso_path=$(download_iso)
    if [ $? -ne 0 ]; then
        exit 1
    fi
    
    # Crear USB booteable
    print_info "Paso 2/3: Creando USB booteable..."
    if ! create_bootable_usb "$iso_path" "$device"; then
        print_error "Error al crear USB booteable"
        exit 1
    fi
    
    # Personalizar USB
    print_info "Paso 3/3: Personalizando USB..."
    customize_usb "$device"
    
    # Completado
    show_completion
}

# Ejecutar main
main "$@"

