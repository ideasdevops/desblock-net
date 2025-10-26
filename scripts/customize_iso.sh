#!/bin/bash

################################################################################
# DESBLOCK-NET - Personalizador de ISO
# Script para personalizar una ISO de Linux Mint con DESBLOCK-NET preinstalado
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
WORK_DIR="/tmp/desblock-iso-work"
MOUNT_DIR="$WORK_DIR/mount"
EXTRACT_DIR="$WORK_DIR/extract"

print_header() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║           🎨 DESBLOCK-NET ISO CUSTOMIZER                 ║"
    echo "║                                                           ║"
    echo "║    Personaliza Linux Mint ISO con DESBLOCK-NET          ║"
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
    
    local deps=("genisoimage" "squashfs-tools" "xorriso" "isolinux")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null && ! dpkg -l | grep -q "$dep"; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        print_error "Faltan las siguientes dependencias: ${missing[*]}"
        print_info "Instalando dependencias faltantes..."
        apt update && apt install -y "${missing[@]}"
    fi
    
    print_success "Todas las dependencias están instaladas"
}

cleanup() {
    print_info "Limpiando archivos temporales..."
    
    # Desmontar si está montado
    if mount | grep -q "$MOUNT_DIR"; then
        umount "$MOUNT_DIR" 2>/dev/null || true
    fi
    
    # Eliminar directorio de trabajo
    rm -rf "$WORK_DIR"
    
    print_success "Limpieza completada"
}

extract_iso() {
    local iso_path=$1
    
    print_info "Extrayendo ISO..."
    
    # Crear directorios
    mkdir -p "$MOUNT_DIR" "$EXTRACT_DIR"
    
    # Montar ISO
    mount -o loop "$iso_path" "$MOUNT_DIR"
    
    # Copiar contenido
    rsync -av "$MOUNT_DIR/" "$EXTRACT_DIR/"
    
    # Desmontar
    umount "$MOUNT_DIR"
    
    print_success "ISO extraída exitosamente"
}

extract_squashfs() {
    print_info "Extrayendo sistema de archivos..."
    
    local squashfs_path="$EXTRACT_DIR/casper/filesystem.squashfs"
    local squashfs_dir="$WORK_DIR/squashfs"
    
    if [ ! -f "$squashfs_path" ]; then
        squashfs_path="$EXTRACT_DIR/live/filesystem.squashfs"
    fi
    
    if [ ! -f "$squashfs_path" ]; then
        print_error "No se encontró filesystem.squashfs"
        return 1
    fi
    
    # Extraer squashfs
    unsquashfs -d "$squashfs_dir" "$squashfs_path"
    
    print_success "Sistema de archivos extraído"
    
    echo "$squashfs_dir"
}

customize_filesystem() {
    local squashfs_dir=$1
    
    print_info "Personalizando sistema de archivos..."
    
    # Copiar DESBLOCK-NET
    print_info "Instalando DESBLOCK-NET..."
    local desblock_target="$squashfs_dir/opt/desblock-net"
    mkdir -p "$desblock_target"
    
    cp -r "$PROJECT_DIR/src" "$desblock_target/"
    cp -r "$PROJECT_DIR/config" "$desblock_target/"
    cp "$PROJECT_DIR/README.md" "$desblock_target/"
    cp "$PROJECT_DIR/LICENSE" "$desblock_target/"
    
    # Crear launcher script
    cat > "$squashfs_dir/usr/local/bin/desblock-net" << 'EOF'
#!/bin/bash
cd /opt/desblock-net/src
python3 gui_app.py
EOF
    
    chmod +x "$squashfs_dir/usr/local/bin/desblock-net"
    
    # Crear .desktop file
    mkdir -p "$squashfs_dir/usr/share/applications"
    cat > "$squashfs_dir/usr/share/applications/desblock-net.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=DESBLOCK-NET
Comment=Sistema de Desbloqueo Conectar Igualdad
Exec=/usr/local/bin/desblock-net
Icon=system-lock-screen
Terminal=false
Categories=System;Utility;
Keywords=unlock;desbloqueo;conectar;igualdad;
EOF
    
    # Crear acceso directo en escritorio de live user
    local desktop_dirs=(
        "$squashfs_dir/etc/skel/Desktop"
        "$squashfs_dir/etc/skel/Escritorio"
        "$squashfs_dir/home/*/Desktop"
        "$squashfs_dir/home/*/Escritorio"
    )
    
    for desktop_dir in "${desktop_dirs[@]}"; do
        if [ -d "$desktop_dir" ] || mkdir -p "$desktop_dir" 2>/dev/null; then
            cp "$squashfs_dir/usr/share/applications/desblock-net.desktop" "$desktop_dir/" 2>/dev/null || true
            chmod +x "$desktop_dir/desblock-net.desktop" 2>/dev/null || true
        fi
    done
    
    # Personalizar mensaje de bienvenida
    cat > "$squashfs_dir/etc/motd" << 'EOF'

╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║              🔓 DESBLOCK-NET LIVE SYSTEM                 ║
║                                                           ║
║        Sistema de Desbloqueo Conectar Igualdad          ║
║                                                           ║
║  Para usar: Busca el ícono DESBLOCK-NET en el escritorio ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

EOF
    
    # Agregar configuración de autostart (opcional)
    mkdir -p "$squashfs_dir/etc/xdg/autostart"
    cat > "$squashfs_dir/etc/xdg/autostart/desblock-net-welcome.desktop" << 'EOF'
[Desktop Entry]
Type=Application
Name=DESBLOCK-NET Welcome
Exec=zenity --info --title="DESBLOCK-NET" --text="Bienvenido a DESBLOCK-NET\n\nBusca el ícono de DESBLOCK-NET en el escritorio para comenzar." --width=400
Terminal=false
NoDisplay=true
X-GNOME-Autostart-enabled=true
EOF
    
    print_success "Sistema personalizado exitosamente"
}

repack_squashfs() {
    local squashfs_dir=$1
    local output_path=$2
    
    print_info "Reempaquetando sistema de archivos..."
    print_warning "Esto puede tardar varios minutos..."
    
    # Eliminar squashfs anterior
    rm -f "$output_path"
    
    # Crear nuevo squashfs
    mksquashfs "$squashfs_dir" "$output_path" \
        -comp xz \
        -b 1M \
        -Xdict-size 100% \
        -no-recovery
    
    print_success "Sistema reempaquetado"
}

update_iso_metadata() {
    print_info "Actualizando metadatos de ISO..."
    
    # Actualizar tamaño del filesystem
    local squashfs_path="$EXTRACT_DIR/casper/filesystem.squashfs"
    if [ ! -f "$squashfs_path" ]; then
        squashfs_path="$EXTRACT_DIR/live/filesystem.squashfs"
    fi
    
    if [ -f "$squashfs_path" ]; then
        local size=$(du -sx --block-size=1 "$WORK_DIR/squashfs" | cut -f1)
        echo "$size" > "$(dirname "$squashfs_path")/filesystem.size"
    fi
    
    # Actualizar checksums
    cd "$EXTRACT_DIR"
    find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > md5sum.txt
    cd - > /dev/null
    
    print_success "Metadatos actualizados"
}

create_iso() {
    local output_iso=$1
    
    print_info "Creando nueva ISO..."
    print_warning "Esto puede tardar varios minutos..."
    
    # Eliminar ISO anterior si existe
    rm -f "$output_iso"
    
    # Crear ISO
    cd "$EXTRACT_DIR"
    
    genisoimage \
        -r -V "DESBLOCK-NET" \
        -cache-inodes \
        -J -l \
        -b isolinux/isolinux.bin \
        -c isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -eltorito-alt-boot \
        -e boot/grub/efi.img \
        -no-emul-boot \
        -o "$output_iso" \
        .
    
    cd - > /dev/null
    
    # Hacer ISO híbrida (booteable en USB)
    isohybrid --uefi "$output_iso" 2>/dev/null || true
    
    print_success "ISO creada: $output_iso"
}

show_completion() {
    local iso_path=$1
    local iso_size=$(du -h "$iso_path" | cut -f1)
    
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}║         ✓ ISO PERSONALIZADA CREADA EXITOSAMENTE         ║${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    print_info "Archivo: $iso_path"
    print_info "Tamaño: $iso_size"
    echo ""
    print_info "Próximos pasos:"
    echo "  1. Prueba la ISO en una máquina virtual:"
    echo "     VirtualBox, VMware, QEMU, etc."
    echo ""
    echo "  2. Crea un USB booteable:"
    echo "     sudo dd if=$iso_path of=/dev/sdX bs=4M status=progress"
    echo ""
    echo "  3. O usa el script de creación de USB:"
    echo "     sudo ./scripts/create_bootable_usb.sh /dev/sdX"
    echo ""
}

main() {
    print_header
    
    # Verificar root
    check_root
    
    # Verificar dependencias
    check_dependencies
    
    # Obtener ISO de entrada
    if [ -z "$1" ]; then
        print_error "Uso: $0 <iso-original> [iso-salida]"
        print_info "Ejemplo: $0 linuxmint-22-cinnamon-64bit.iso desblock-net-v1.iso"
        exit 1
    fi
    
    local input_iso=$1
    local output_iso="${2:-desblock-net-$(date +%Y%m%d).iso}"
    
    # Validar ISO de entrada
    if [ ! -f "$input_iso" ]; then
        print_error "El archivo ISO no existe: $input_iso"
        exit 1
    fi
    
    print_info "ISO de entrada: $input_iso"
    print_info "ISO de salida: $output_iso"
    echo ""
    
    # Configurar trap para limpieza
    trap cleanup EXIT
    
    # Proceso de personalización
    print_info "Iniciando proceso de personalización..."
    echo ""
    
    # Paso 1: Extraer ISO
    extract_iso "$input_iso"
    
    # Paso 2: Extraer squashfs
    squashfs_dir=$(extract_squashfs)
    
    # Paso 3: Personalizar
    customize_filesystem "$squashfs_dir"
    
    # Paso 4: Reempaquetar squashfs
    local squashfs_output="$EXTRACT_DIR/casper/filesystem.squashfs"
    if [ ! -d "$EXTRACT_DIR/casper" ]; then
        squashfs_output="$EXTRACT_DIR/live/filesystem.squashfs"
    fi
    repack_squashfs "$squashfs_dir" "$squashfs_output"
    
    # Paso 5: Actualizar metadatos
    update_iso_metadata
    
    # Paso 6: Crear ISO final
    create_iso "$output_iso"
    
    # Completado
    show_completion "$output_iso"
}

# Ejecutar main
main "$@"

