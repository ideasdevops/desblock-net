# 🔧 Manual Técnico - DESBLOCK-NET

## Índice
1. [Arquitectura del Sistema](#arquitectura-del-sistema)
2. [Componentes](#componentes)
3. [Algoritmos de Desbloqueo](#algoritmos-de-desbloqueo)
4. [Instalación y Configuración](#instalación-y-configuración)
5. [API y Uso Programático](#api-y-uso-programático)
6. [Desarrollo y Contribución](#desarrollo-y-contribución)
7. [Seguridad](#seguridad)
8. [Troubleshooting Avanzado](#troubleshooting-avanzado)

---

## Arquitectura del Sistema

### Diagrama General

```
┌─────────────────────────────────────────────────────────┐
│                    DESBLOCK-NET                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌──────────────┐     ┌──────────────┐                │
│  │   GUI Layer  │────▶│  CLI Layer   │                │
│  │  (gui_app.py)│     │ (unlock_     │                │
│  │              │     │  generator.  │                │
│  └──────────────┘     │  py --cli)   │                │
│         │             └──────────────┘                │
│         │                     │                        │
│         ▼                     ▼                        │
│  ┌──────────────────────────────────┐                │
│  │    Core Generator Module         │                │
│  │    (UnlockCodeGenerator)         │                │
│  │  ┌────────────────────────────┐  │                │
│  │  │ • validate_hardware_id()   │  │                │
│  │  │ • validate_boot_mark()     │  │                │
│  │  │ • generate_code_citd_v1()  │  │                │
│  │  │ • generate_code_tds_v2()   │  │                │
│  │  │ • save_unlock_log()        │  │                │
│  │  └────────────────────────────┘  │                │
│  └──────────────────────────────────┘                │
│         │                     │                        │
│         ▼                     ▼                        │
│  ┌─────────────┐     ┌─────────────┐                │
│  │   Config    │     │   Utils     │                │
│  │   Module    │     │   Module    │                │
│  └─────────────┘     └─────────────┘                │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                  Linux Mint Live USB                    │
└─────────────────────────────────────────────────────────┘
```

### Stack Tecnológico

- **Lenguaje**: Python 3.6+
- **GUI**: Tkinter (incluido en Python)
- **Sistema Base**: Linux Mint 22 Cinnamon
- **Formato USB**: ISO 9660 + Booteable
- **Hash Algorithm**: SHA-256
- **Configuración**: JSON

---

## Componentes

### 1. unlock_generator.py

**Módulo Core** - Generador de códigos de desbloqueo

```python
class UnlockCodeGenerator:
    """
    Clase principal para generación de códigos
    
    Atributos:
        year (str): Año de entrega del equipo
        server_config (dict): Configuración del servidor
        version (str): Versión del algoritmo (citd_v1 o tds_v2)
    """
```

**Métodos Principales:**

| Método | Descripción | Retorno |
|--------|-------------|---------|
| `validate_hardware_id(hw_id)` | Valida formato del Hardware ID | bool |
| `validate_boot_mark(boot_mark)` | Valida formato de Boot Mark | bool |
| `generate_code_citd_v1(hw, bm)` | Genera código para 2021-2022 | str |
| `generate_code_tds_v2(hw, bm)` | Genera código para 2023 | str |
| `generate_unlock_code(hw, bm)` | Método principal de generación | tuple |
| `save_unlock_log(...)` | Guarda log de desbloqueo | bool |

### 2. gui_app.py

**Interfaz Gráfica de Usuario**

Características:
- Interfaz moderna con Tkinter
- Soporte para tema oscuro
- Validación en tiempo real
- Copia al portapapeles
- Logging opcional

### 3. utils.py

**Módulo de Utilidades**

Funciones disponibles:
- `get_system_info()`: Información del sistema operativo
- `check_dependencies()`: Verificación de dependencias
- `get_usb_devices()`: Lista dispositivos USB
- `validate_iso_file()`: Valida archivos ISO
- `calculate_file_hash()`: Calcula hash de archivos
- `create_desktop_shortcut()`: Crea accesos directos

---

## Algoritmos de Desbloqueo

### Sistema CITD (2021-2022)

**Versión**: citd_v1  
**Servidor**: citd.dgp.educ.ar

```python
def generate_code_citd_v1(hardware_id, boot_mark):
    # 1. Normalización
    hw_clean = hardware_id.upper().replace("-", "").replace("_", "")
    bm_clean = boot_mark.upper().replace("-", "").replace("_", "")
    
    # 2. Combinación con sal
    salt = "CITD_UNLOCK_2021_2022"
    combined = f"{hw_clean}{bm_clean}{salt}"
    
    # 3. Hash SHA-256
    hash_hex = hashlib.sha256(combined.encode()).hexdigest()
    
    # 4. Extracción de código (formato: XXXX-XXXX-XXXX-XXXX)
    code = f"{hash_hex[0:4]}-{hash_hex[8:12]}-{hash_hex[16:20]}-{hash_hex[24:28]}"
    
    return code.upper()
```

**Características:**
- Formato de salida: 4 bloques de 4 caracteres
- Caracteres: Hexadecimales (0-9, A-F)
- Longitud total: 19 caracteres (incluyendo guiones)

### Sistema TDS (2023)

**Versión**: tds_v2  
**Servidor**: tds.educacion.gob.ar

```python
def generate_code_tds_v2(hardware_id, boot_mark):
    # 1. Normalización
    hw_clean = hardware_id.upper().replace("-", "").replace("_", "")
    bm_clean = boot_mark.upper().replace("-", "").replace("_", "")
    
    # 2. Combinación con sal (orden diferente)
    salt = "TDS_UNLOCK_2023"
    combined = f"{salt}{hw_clean}{bm_clean}"
    
    # 3. Hash SHA-256
    hash_hex = hashlib.sha256(combined.encode()).hexdigest()
    
    # 4. Extracción de código (formato: XXXXX-XXXXX-XXXXX)
    code = f"{hash_hex[0:5]}-{hash_hex[10:15]}-{hash_hex[20:25]}"
    
    return code.upper()
```

**Características:**
- Formato de salida: 3 bloques de 5 caracteres
- Caracteres: Hexadecimales (0-9, A-F)
- Longitud total: 17 caracteres (incluyendo guiones)

### Diferencias entre Versiones

| Aspecto | CITD v1 (2021-2022) | TDS v2 (2023) |
|---------|---------------------|---------------|
| Bloques | 4 × 4 caracteres | 3 × 5 caracteres |
| Sal | Sufijo | Prefijo |
| Posiciones Hash | 0-4, 8-12, 16-20, 24-28 | 0-5, 10-15, 20-25 |
| Servidor | citd.dgp.educ.ar | tds.educacion.gob.ar |

---

## Instalación y Configuración

### Instalación Manual

#### 1. Clonar Repositorio
```bash
git clone https://github.com/tu-usuario/DESBLOCK-NET.git
cd DESBLOCK-NET
```

#### 2. Verificar Python
```bash
python3 --version  # Debe ser 3.6 o superior
```

#### 3. Instalar Dependencias del Sistema
```bash
# Debian/Ubuntu/Mint
sudo apt install python3 python3-tk wget dd parted

# Fedora
sudo dnf install python3 python3-tkinter wget dd parted

# Arch
sudo pacman -S python tk wget dd parted
```

#### 4. Dar Permisos a Scripts
```bash
chmod +x scripts/*.sh
chmod +x src/*.py
```

### Configuración Avanzada

#### Archivo: config/settings.json

```json
{
  "logging": {
    "enabled": true,
    "directory": "~/desblock-net-logs",
    "anonymize_data": true
  },
  "security": {
    "require_confirmation": true,
    "validate_input": true,
    "max_attempts": 5
  }
}
```

#### Archivo: config/servers.json

Define la configuración de servidores por año:
- Endpoints de validación
- URLs de soporte
- Información por provincia

---

## API y Uso Programático

### Importación del Módulo

```python
from unlock_generator import UnlockCodeGenerator

# Crear instancia para año 2023
generator = UnlockCodeGenerator(year="2023")

# Generar código
success, message, code = generator.generate_unlock_code(
    hardware_id="ABC123DEF456",
    boot_mark="987654321"
)

if success:
    print(f"Código generado: {code}")
else:
    print(f"Error: {message}")
```

### Uso desde Línea de Comandos

```bash
# Sintaxis básica
python3 unlock_generator.py \
    --year 2023 \
    --hardware-id "ABC123DEF456" \
    --boot-mark "987654321"

# Con guardado de log
python3 unlock_generator.py \
    --year 2022 \
    --hardware-id "XYZ789GHI012" \
    --boot-mark "123456789" \
    --save-log

# Ver ayuda
python3 unlock_generator.py --help
```

### Integración en Scripts

```python
#!/usr/bin/env python3
import sys
from unlock_generator import UnlockCodeGenerator

def desbloquear_multiple(equipos):
    """
    Desbloquea múltiples equipos
    
    Args:
        equipos: Lista de tuplas (hw_id, boot_mark, year)
    """
    resultados = []
    
    for hw_id, boot_mark, year in equipos:
        gen = UnlockCodeGenerator(year=year)
        success, msg, code = gen.generate_unlock_code(hw_id, boot_mark)
        
        resultados.append({
            'hw_id': hw_id[-4:],  # Solo últimos 4 caracteres
            'success': success,
            'code': code if success else None,
            'message': msg
        })
    
    return resultados

# Uso
equipos = [
    ("ABC123", "123456", "2023"),
    ("DEF456", "789012", "2022"),
]

for resultado in desbloquear_multiple(equipos):
    print(resultado)
```

---

## Desarrollo y Contribución

### Estructura de Desarrollo

```
DESBLOCK-NET/
├── src/              # Código fuente
├── scripts/          # Scripts de automatización
├── config/           # Configuraciones
├── docs/             # Documentación
├── tests/            # Tests unitarios (opcional)
└── .git/             # Control de versiones
```

### Guía de Contribución

1. **Fork del Repositorio**
```bash
git clone https://github.com/TU-USUARIO/DESBLOCK-NET.git
cd DESBLOCK-NET
```

2. **Crear Rama de Feature**
```bash
git checkout -b feature/nueva-funcionalidad
```

3. **Hacer Cambios y Commit**
```bash
git add .
git commit -m "feat: Agrega nueva funcionalidad X"
```

4. **Push y Pull Request**
```bash
git push origin feature/nueva-funcionalidad
```

### Estándares de Código

- **PEP 8**: Seguir guía de estilo de Python
- **Docstrings**: Documentar todas las funciones
- **Type Hints**: Usar anotaciones de tipo cuando sea posible
- **Comentarios**: Código auto-documentado con comentarios claros

### Testing

```bash
# Ejecutar tests unitarios (cuando estén disponibles)
python3 -m pytest tests/

# Test manual de generador
python3 src/unlock_generator.py --year 2023 --hardware-id "TEST123" --boot-mark "456789"
```

---

## Seguridad

### Consideraciones de Seguridad

1. **No se almacenan datos sensibles**
   - Solo se guardan los últimos 4 caracteres en logs
   - Los logs son opcionales y locales

2. **Validación de entrada**
   - Todos los inputs son validados
   - Límite de intentos configurables

3. **Sin comunicación externa**
   - No se envían datos a servidores externos
   - Generación 100% local

4. **Código abierto**
   - Auditable por cualquiera
   - Sin ofuscación

### Análisis de Vulnerabilidades

```bash
# Scan con bandit (opcional)
pip3 install bandit
bandit -r src/

# Análisis estático
pip3 install pylint
pylint src/*.py
```

---

## Troubleshooting Avanzado

### Problema: Python no encuentra tkinter

**Síntoma:**
```
ModuleNotFoundError: No module named '_tkinter'
```

**Solución:**
```bash
# Debian/Ubuntu
sudo apt install python3-tk

# Fedora
sudo dnf install python3-tkinter

# Verificar
python3 -c "import tkinter; print('OK')"
```

### Problema: USB no bootea

**Diagnóstico:**
```bash
# Verificar que sea booteable
file -s /dev/sdX
fdisk -l /dev/sdX

# Verificar firma ISO
dd if=/dev/sdX bs=1 skip=32769 count=5 2>/dev/null | xxd
# Debe mostrar: CD001
```

**Solución:**
1. Recrear USB con dd directamente:
```bash
sudo dd if=linuxmint.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

2. Verificar BIOS:
   - Secure Boot: Deshabilitado
   - Boot Mode: Legacy o UEFI
   - Boot Order: USB primero

### Problema: Código no funciona

**Diagnóstico:**
```python
# Verificar generación paso a paso
from unlock_generator import UnlockCodeGenerator
import hashlib

hw = "ABC123"
bm = "456789"
year = "2023"

gen = UnlockCodeGenerator(year=year)

# Verificar normalización
hw_clean = hw.upper().replace("-", "")
print(f"HW Clean: {hw_clean}")

# Verificar hash
combined = f"TDS_UNLOCK_2023{hw_clean}{bm}"
hash_hex = hashlib.sha256(combined.encode()).hexdigest()
print(f"Hash: {hash_hex}")

# Verificar código
success, msg, code = gen.generate_unlock_code(hw, bm)
print(f"Código: {code}")
```

### Logs de Depuración

```bash
# Activar modo debug
export DESBLOCK_DEBUG=1

# Ejecutar con verbose
python3 -v src/gui_app.py

# Ver logs
tail -f ~/desblock-net-logs/*.json
```

---

## Apéndices

### A. Tabla de Compatibilidad

| Año | Versión | Servidor | Modelos |
|-----|---------|----------|---------|
| 2021 | citd_v1 | citd.dgp.educ.ar | Dell Vostro, Exo |
| 2022 | citd_v1 | citd.dgp.educ.ar | Dell Vostro |
| 2023 | tds_v2 | tds.educacion.gob.ar | Dell Vostro |

### B. Códigos de Error

| Código | Descripción | Solución |
|--------|-------------|----------|
| ERR_001 | Hardware ID inválido | Verificar formato |
| ERR_002 | Boot Mark inválido | Verificar formato |
| ERR_003 | Año no soportado | Usar 2021, 2022 o 2023 |
| ERR_004 | Error de generación | Ver logs detallados |

### C. Referencias

- [Conectar Igualdad Oficial](https://conectarigualdad.gob.ar/)
- [Linux Mint](https://linuxmint.com/)
- [Python hashlib](https://docs.python.org/3/library/hashlib.html)
- [Tkinter Documentation](https://docs.python.org/3/library/tkinter.html)

---

**Documento actualizado**: 2024-10-26  
**Versión**: 1.0.0  
**Mantenedor**: Comunidad DESBLOCK-NET

