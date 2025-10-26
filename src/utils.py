#!/usr/bin/env python3
"""
DESBLOCK-NET - Utilidades
Funciones auxiliares para el sistema de desbloqueo
"""

import os
import sys
import json
import hashlib
import subprocess
from typing import List, Dict, Optional, Tuple
from pathlib import Path
from datetime import datetime


def get_system_info() -> Dict[str, str]:
    """
    Obtiene información del sistema operativo.
    
    Returns:
        Diccionario con información del sistema
    """
    import platform
    
    return {
        "os": platform.system(),
        "os_version": platform.version(),
        "architecture": platform.machine(),
        "python_version": platform.python_version(),
        "hostname": platform.node()
    }


def check_dependencies() -> Tuple[bool, List[str]]:
    """
    Verifica que todas las dependencias estén instaladas.
    
    Returns:
        Tupla (todas_instaladas, lista_faltantes)
    """
    dependencies = {
        "tkinter": "tkinter",
        "hashlib": "hashlib",
        "json": "json"
    }
    
    missing = []
    
    for name, module in dependencies.items():
        try:
            __import__(module)
        except ImportError:
            missing.append(name)
    
    return len(missing) == 0, missing


def is_usb_device(device_path: str) -> bool:
    """
    Verifica si un dispositivo es un USB.
    
    Args:
        device_path: Ruta del dispositivo (ej: /dev/sdb)
        
    Returns:
        True si es dispositivo USB, False en caso contrario
    """
    if not os.path.exists(device_path):
        return False
    
    # En Linux, verificar en /sys
    if sys.platform.startswith('linux'):
        device_name = os.path.basename(device_path)
        usb_path = f"/sys/block/{device_name}/removable"
        
        if os.path.exists(usb_path):
            try:
                with open(usb_path, 'r') as f:
                    return f.read().strip() == '1'
            except:
                pass
    
    return False


def get_usb_devices() -> List[Dict[str, str]]:
    """
    Lista todos los dispositivos USB conectados.
    
    Returns:
        Lista de diccionarios con información de dispositivos USB
    """
    devices = []
    
    if sys.platform.startswith('linux'):
        try:
            # Usar lsblk para listar dispositivos
            result = subprocess.run(
                ['lsblk', '-J', '-o', 'NAME,SIZE,TYPE,MOUNTPOINT,TRAN'],
                capture_output=True,
                text=True
            )
            
            if result.returncode == 0:
                data = json.loads(result.stdout)
                
                for device in data.get('blockdevices', []):
                    if device.get('tran') == 'usb' and device.get('type') == 'disk':
                        devices.append({
                            'name': device['name'],
                            'path': f"/dev/{device['name']}",
                            'size': device.get('size', 'Unknown'),
                            'mountpoint': device.get('mountpoint', '')
                        })
        except:
            pass
    
    return devices


def format_bytes(bytes_value: int) -> str:
    """
    Formatea bytes a unidad legible.
    
    Args:
        bytes_value: Valor en bytes
        
    Returns:
        String formateado (ej: "1.5 GB")
    """
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if bytes_value < 1024.0:
            return f"{bytes_value:.1f} {unit}"
        bytes_value /= 1024.0
    
    return f"{bytes_value:.1f} PB"


def validate_iso_file(iso_path: str) -> Tuple[bool, str]:
    """
    Valida que un archivo ISO sea válido.
    
    Args:
        iso_path: Ruta al archivo ISO
        
    Returns:
        Tupla (es_valido, mensaje)
    """
    if not os.path.exists(iso_path):
        return False, "El archivo ISO no existe"
    
    if not iso_path.endswith('.iso'):
        return False, "El archivo no tiene extensión .iso"
    
    # Verificar tamaño mínimo (100 MB)
    size = os.path.getsize(iso_path)
    if size < 100 * 1024 * 1024:
        return False, f"El archivo ISO es muy pequeño ({format_bytes(size)})"
    
    # Verificar firma ISO (primeros bytes)
    try:
        with open(iso_path, 'rb') as f:
            # Saltar a byte 32769 donde está la firma ISO
            f.seek(32769)
            signature = f.read(5)
            
            if signature == b'CD001':
                return True, f"Archivo ISO válido ({format_bytes(size)})"
    except Exception as e:
        return False, f"Error al leer archivo: {str(e)}"
    
    return False, "Archivo ISO no válido o corrupto"


def calculate_file_hash(file_path: str, algorithm: str = 'sha256') -> Optional[str]:
    """
    Calcula el hash de un archivo.
    
    Args:
        file_path: Ruta al archivo
        algorithm: Algoritmo de hash (md5, sha1, sha256)
        
    Returns:
        Hash del archivo o None si hay error
    """
    try:
        hash_obj = hashlib.new(algorithm)
        
        with open(file_path, 'rb') as f:
            # Leer en bloques de 64KB
            for chunk in iter(lambda: f.read(65536), b''):
                hash_obj.update(chunk)
        
        return hash_obj.hexdigest()
    except Exception as e:
        print(f"Error al calcular hash: {e}")
        return None


def create_desktop_shortcut(app_name: str, exec_path: str, icon_path: Optional[str] = None) -> bool:
    """
    Crea un acceso directo en el escritorio.
    
    Args:
        app_name: Nombre de la aplicación
        exec_path: Ruta al ejecutable
        icon_path: Ruta al icono (opcional)
        
    Returns:
        True si se creó correctamente, False en caso contrario
    """
    if sys.platform.startswith('linux'):
        desktop_path = os.path.expanduser("~/Desktop")
        
        if not os.path.exists(desktop_path):
            desktop_path = os.path.expanduser("~/Escritorio")
        
        if not os.path.exists(desktop_path):
            return False
        
        shortcut_path = os.path.join(desktop_path, f"{app_name}.desktop")
        
        try:
            content = "[Desktop Entry]\n"
            content += f"Name={app_name}\n"
            content += "Type=Application\n"
            content += f"Exec={exec_path}\n"
            content += "Terminal=false\n"
            content += "Categories=Utility;System;\n"
            
            if icon_path and os.path.exists(icon_path):
                content += f"Icon={icon_path}\n"
            
            with open(shortcut_path, 'w') as f:
                f.write(content)
            
            # Hacer ejecutable
            os.chmod(shortcut_path, 0o755)
            
            return True
        except Exception as e:
            print(f"Error al crear acceso directo: {e}")
            return False
    
    return False


def read_config(config_path: str) -> Dict:
    """
    Lee un archivo de configuración JSON.
    
    Args:
        config_path: Ruta al archivo de configuración
        
    Returns:
        Diccionario con la configuración o diccionario vacío
    """
    if not os.path.exists(config_path):
        return {}
    
    try:
        with open(config_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error al leer configuración: {e}")
        return {}


def write_config(config_path: str, config_data: Dict) -> bool:
    """
    Escribe un archivo de configuración JSON.
    
    Args:
        config_path: Ruta al archivo de configuración
        config_data: Diccionario con la configuración
        
    Returns:
        True si se guardó correctamente, False en caso contrario
    """
    try:
        # Crear directorio si no existe
        os.makedirs(os.path.dirname(config_path), exist_ok=True)
        
        with open(config_path, 'w', encoding='utf-8') as f:
            json.dump(config_data, f, indent=2, ensure_ascii=False)
        
        return True
    except Exception as e:
        print(f"Error al guardar configuración: {e}")
        return False


def get_app_version() -> str:
    """
    Obtiene la versión de la aplicación.
    
    Returns:
        String con la versión
    """
    return "1.0.0"


def get_app_info() -> Dict[str, str]:
    """
    Obtiene información completa de la aplicación.
    
    Returns:
        Diccionario con información de la aplicación
    """
    return {
        "name": "DESBLOCK-NET",
        "version": get_app_version(),
        "description": "Sistema de desbloqueo para equipos Conectar Igualdad",
        "author": "Comunidad DESBLOCK-NET",
        "license": "MIT",
        "repository": "https://github.com/tu-usuario/DESBLOCK-NET"
    }


def print_banner():
    """
    Imprime el banner de la aplicación.
    """
    banner = """
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║                    🔓 DESBLOCK-NET                        ║
    ║                                                           ║
    ║        Sistema de Desbloqueo Conectar Igualdad          ║
    ║                    2021 - 2023                           ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
    """
    print(banner)


def main():
    """Función principal para pruebas."""
    print_banner()
    
    print("\n📊 Información del Sistema:")
    print("="*60)
    system_info = get_system_info()
    for key, value in system_info.items():
        print(f"  {key}: {value}")
    
    print("\n🔍 Verificando dependencias...")
    all_installed, missing = check_dependencies()
    if all_installed:
        print("  ✓ Todas las dependencias están instaladas")
    else:
        print(f"  ✗ Faltan dependencias: {', '.join(missing)}")
    
    print("\n💾 Dispositivos USB:")
    print("="*60)
    usb_devices = get_usb_devices()
    if usb_devices:
        for device in usb_devices:
            print(f"  • {device['name']} ({device['size']}) - {device['path']}")
    else:
        print("  No se encontraron dispositivos USB")
    
    print("\n📦 Información de la Aplicación:")
    print("="*60)
    app_info = get_app_info()
    for key, value in app_info.items():
        print(f"  {key}: {value}")
    
    print("\n")


if __name__ == "__main__":
    main()

