#!/bin/bash

################################################################################
# DESBLOCK-NET - Instalador de Dependencias
# Script para instalar todas las dependencias necesarias
################################################################################

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║         🔧 DESBLOCK-NET DEPENDENCY INSTALLER             ║"
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

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

install_debian_ubuntu() {
    print_info "Detectado sistema basado en Debian/Ubuntu"
    print_info "Actualizando repositorios..."
    
    sudo apt update
    
    print_info "Instalando dependencias..."
    sudo apt install -y \
        python3 \
        python3-pip \
        python3-tk \
        wget \
        curl \
        git \
        dd \
        parted \
        dosfstools \
        rsync
    
    print_success "Dependencias instaladas"
}

install_fedora() {
    print_info "Detectado sistema Fedora"
    print_info "Instalando dependencias..."
    
    sudo dnf install -y \
        python3 \
        python3-pip \
        python3-tkinter \
        wget \
        curl \
        git \
        dd \
        parted \
        dosfstools \
        rsync
    
    print_success "Dependencias instaladas"
}

install_arch() {
    print_info "Detectado sistema Arch Linux"
    print_info "Instalando dependencias..."
    
    sudo pacman -S --noconfirm \
        python \
        python-pip \
        tk \
        wget \
        curl \
        git \
        parted \
        dosfstools \
        rsync
    
    print_success "Dependencias instaladas"
}

install_python_packages() {
    print_info "Instalando paquetes Python..."
    
    # Crear requirements.txt si no existe
    cat > /tmp/desblock-requirements.txt << EOF
# DESBLOCK-NET Python Requirements
# No se requieren paquetes externos adicionales
# El proyecto usa solo módulos estándar de Python
EOF
    
    print_success "Paquetes Python verificados"
}

verify_installation() {
    print_info "Verificando instalación..."
    
    local errors=0
    
    # Verificar Python
    if command -v python3 &> /dev/null; then
        local python_version=$(python3 --version)
        print_success "Python: $python_version"
    else
        print_error "Python 3 no está instalado"
        errors=$((errors + 1))
    fi
    
    # Verificar tkinter
    if python3 -c "import tkinter" 2>/dev/null; then
        print_success "Tkinter: Instalado"
    else
        print_error "Tkinter no está instalado"
        errors=$((errors + 1))
    fi
    
    # Verificar herramientas del sistema
    local tools=("wget" "dd" "parted" "git")
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            print_success "$tool: Instalado"
        else
            print_error "$tool no está instalado"
            errors=$((errors + 1))
        fi
    done
    
    if [ $errors -eq 0 ]; then
        echo ""
        print_success "✓ Todas las dependencias están correctamente instaladas"
        return 0
    else
        echo ""
        print_error "✗ Faltan $errors dependencias"
        return 1
    fi
}

show_completion() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}║         ✓ INSTALACIÓN COMPLETADA EXITOSAMENTE            ║${NC}"
    echo -e "${GREEN}║                                                           ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    print_info "Próximos pasos:"
    echo "  1. Para probar la aplicación GUI:"
    echo "     cd src && python3 gui_app.py"
    echo ""
    echo "  2. Para usar desde línea de comandos:"
    echo "     cd src && python3 unlock_generator.py --help"
    echo ""
    echo "  3. Para crear USB booteable:"
    echo "     sudo ./scripts/create_bootable_usb.sh /dev/sdX"
    echo ""
}

main() {
    print_header
    
    # Detectar sistema operativo
    os=$(detect_os)
    
    case "$os" in
        ubuntu|debian|linuxmint|pop)
            install_debian_ubuntu
            ;;
        fedora|rhel|centos)
            install_fedora
            ;;
        arch|manjaro)
            install_arch
            ;;
        *)
            print_error "Sistema operativo no soportado: $os"
            print_info "Por favor instale manualmente:"
            echo "  - Python 3"
            echo "  - Python 3 Tkinter"
            echo "  - wget, dd, parted, git"
            exit 1
            ;;
    esac
    
    # Instalar paquetes Python
    install_python_packages
    
    # Verificar instalación
    if verify_installation; then
        show_completion
        exit 0
    else
        print_error "La instalación no se completó correctamente"
        exit 1
    fi
}

main "$@"

