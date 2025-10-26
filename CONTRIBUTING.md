# 🤝 Contribuyendo a DESBLOCK-NET

¡Gracias por tu interés en contribuir a DESBLOCK-NET! Este proyecto es mantenido por la comunidad y todas las contribuciones son bienvenidas.

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [¿Cómo puedo contribuir?](#cómo-puedo-contribuir)
- [Guía de Desarrollo](#guía-de-desarrollo)
- [Proceso de Pull Request](#proceso-de-pull-request)
- [Estándares de Código](#estándares-de-código)
- [Reportar Bugs](#reportar-bugs)
- [Sugerir Mejoras](#sugerir-mejoras)

## 📜 Código de Conducta

Este proyecto se adhiere a un código de conducta. Al participar, se espera que mantengas este código. Por favor reporta comportamiento inaceptable a los mantenedores del proyecto.

### Nuestro Compromiso

- Respetar diferentes puntos de vista y experiencias
- Aceptar críticas constructivas
- Enfocarnos en lo que es mejor para la comunidad
- Mostrar empatía hacia otros miembros de la comunidad

## 🎯 ¿Cómo puedo contribuir?

### 1. Reportar Bugs 🐛

Si encuentras un bug, por favor:

1. Verifica que no esté ya reportado en [Issues](https://github.com/tu-usuario/DESBLOCK-NET/issues)
2. Abre un nuevo Issue con:
   - Título descriptivo
   - Pasos para reproducir
   - Comportamiento esperado vs actual
   - Información del sistema (OS, versión Python, etc.)
   - Screenshots si aplica

### 2. Sugerir Mejoras 💡

Para sugerencias de nuevas características:

1. Abre un Issue con el tag "enhancement"
2. Describe claramente:
   - El problema que resuelve
   - Comportamiento propuesto
   - Alternativas consideradas

### 3. Contribuir con Código 💻

1. **Fork** del repositorio
2. **Crea una rama** (`git checkout -b feature/AmazingFeature`)
3. **Realiza tus cambios**
4. **Commit** tus cambios (`git commit -m 'Add some AmazingFeature'`)
5. **Push** a la rama (`git push origin feature/AmazingFeature`)
6. Abre un **Pull Request**

### 4. Mejorar Documentación 📚

- Corregir errores tipográficos
- Mejorar explicaciones
- Agregar ejemplos
- Traducir a otros idiomas

### 5. Ayudar a Otros 🙋

- Responder preguntas en Issues
- Ayudar en los foros/grupos de discusión
- Compartir tu experiencia

## 🔧 Guía de Desarrollo

### Requisitos Previos

```bash
# Instalar dependencias de desarrollo
sudo apt install python3 python3-pip python3-tk git

# Clonar el repositorio
git clone https://github.com/tu-usuario/DESBLOCK-NET.git
cd DESBLOCK-NET

# Dar permisos
chmod +x scripts/*.sh src/*.py
```

### Estructura del Proyecto

```
DESBLOCK-NET/
├── src/                    # Código fuente
│   ├── unlock_generator.py # Generador de códigos
│   ├── gui_app.py          # Interfaz gráfica
│   └── utils.py            # Utilidades
├── scripts/                # Scripts de automatización
├── config/                 # Archivos de configuración
├── docs/                   # Documentación
└── tests/                  # Tests (futuro)
```

### Configurar Entorno de Desarrollo

```bash
# (Opcional) Crear entorno virtual
python3 -m venv venv
source venv/bin/activate

# Instalar herramientas de desarrollo (opcional)
pip3 install black flake8 pylint pytest
```

### Ejecutar Tests

```bash
# Test manual del generador
python3 src/unlock_generator.py \
    --year 2023 \
    --hardware-id "TEST123" \
    --boot-mark "456789"

# Test de la GUI
python3 src/gui_app.py

# Test de utilidades
python3 src/utils.py
```

## 🔀 Proceso de Pull Request

### Antes de Enviar

- [ ] El código sigue los [estándares](#estándares-de-código)
- [ ] Comentarios y documentación actualizados
- [ ] Tests manuales realizados
- [ ] Sin conflictos con la rama principal

### Formato del PR

**Título**: Descripción corta y clara

**Descripción**:
```markdown
## Cambios Realizados
- Lista de cambios principales

## Tipo de Cambio
- [ ] Bug fix
- [ ] Nueva característica
- [ ] Mejora de rendimiento
- [ ] Documentación
- [ ] Otro (especificar)

## Testing
- Describe cómo probaste los cambios

## Capturas de Pantalla
(Si aplica)
```

## 📏 Estándares de Código

### Python

Seguir [PEP 8](https://www.python.org/dev/peps/pep-0008/)

```python
# Bueno ✓
def generate_unlock_code(hardware_id: str, boot_mark: str) -> str:
    """
    Genera el código de desbloqueo.
    
    Args:
        hardware_id: ID de hardware del equipo
        boot_mark: Marca de arranque
        
    Returns:
        Código de desbloqueo generado
    """
    pass

# Malo ✗
def genCode(hid,bm):
    pass
```

### Convenciones de Nombres

- **Funciones/Métodos**: `snake_case`
- **Clases**: `PascalCase`
- **Constantes**: `UPPER_SNAKE_CASE`
- **Variables privadas**: `_leading_underscore`

### Documentación

Todas las funciones públicas deben tener docstrings:

```python
def my_function(param1: str, param2: int) -> bool:
    """
    Descripción breve de la función.
    
    Descripción más detallada si es necesario.
    
    Args:
        param1: Descripción del parámetro 1
        param2: Descripción del parámetro 2
        
    Returns:
        Descripción del valor de retorno
        
    Raises:
        ValueError: Cuando y por qué se lanza
    """
    pass
```

### Comentarios

```python
# Bueno ✓
# Normalizar datos eliminando caracteres especiales
hw_clean = hardware_id.upper().replace("-", "")

# Malo ✗
hw_clean = hardware_id.upper().replace("-", "")  # limpiar
```

## 🐛 Reportar Bugs

### Plantilla de Bug Report

```markdown
**Descripción**
Descripción clara y concisa del bug.

**Pasos para Reproducir**
1. Ir a '...'
2. Hacer clic en '....'
3. Ver error

**Comportamiento Esperado**
Descripción de lo que esperabas que sucediera.

**Comportamiento Actual**
Descripción de lo que realmente sucede.

**Screenshots**
Si aplica, agrega screenshots.

**Entorno:**
- OS: [ej. Linux Mint 22]
- Python: [ej. 3.10.5]
- Versión DESBLOCK-NET: [ej. 1.0.0]

**Información Adicional**
Cualquier otra información relevante.
```

## 💡 Sugerir Mejoras

### Plantilla de Feature Request

```markdown
**¿El problema está relacionado con una funcionalidad?**
Descripción clara del problema.

**Solución Propuesta**
Descripción clara de lo que quieres que suceda.

**Alternativas Consideradas**
Descripción de soluciones alternativas que consideraste.

**Contexto Adicional**
Cualquier otro contexto o screenshots.
```

## 🏷️ Tipos de Contribuciones

### Commits

Usar mensajes de commit descriptivos siguiendo [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: Agrega soporte para año 2024
fix: Corrige validación de Boot Mark
docs: Actualiza manual de usuario
style: Formatea código según PEP 8
refactor: Reorganiza estructura de módulos
test: Agrega tests para generador
chore: Actualiza dependencias
```

### Branches

```
feature/nombre-caracteristica    # Nueva característica
bugfix/descripcion-bug          # Corrección de bug
hotfix/problema-critico         # Corrección urgente
docs/actualizacion-docs         # Documentación
refactor/mejora-codigo          # Refactorización
```

## 🎨 Guía de Estilo UI/UX

Si contribuyes a la GUI:

- **Colores**: Mantener paleta actual (oscura)
- **Fuentes**: Arial para texto, Courier para código
- **Espaciado**: Consistente con diseño actual
- **Accesibilidad**: Contraste suficiente, tamaños legibles

## 🧪 Testing

### Test Manual

Antes de enviar un PR, prueba manualmente:

```bash
# 1. Generador CLI
python3 src/unlock_generator.py --year 2023 \
    --hardware-id "TEST123" --boot-mark "456789"

# 2. GUI
python3 src/gui_app.py

# 3. Utilidades
python3 src/utils.py

# 4. Scripts (solo Linux)
./scripts/install_dependencies.sh
```

### Checklist de Testing

- [ ] Funciona en Linux (preferiblemente Linux Mint)
- [ ] Funciona con Python 3.6+
- [ ] No rompe funcionalidad existente
- [ ] Maneja errores apropiadamente
- [ ] UI responsiva (si aplica)

## 📝 Documentación

Al agregar nuevas características, actualizar:

- [ ] README.md (si es característica principal)
- [ ] Documentación técnica (MANUAL_TECNICO.md)
- [ ] Documentación de usuario (MANUAL_USUARIO.md)
- [ ] FAQ (si aplica)
- [ ] Comentarios en código

## 🌍 Internacionalización

Para agregar soporte de idiomas:

1. Crear archivo de traducciones en `config/i18n/`
2. Usar claves de traducción en lugar de texto hardcoded
3. Documentar nuevos idiomas en README

## 🏆 Reconocimientos

Los contribuidores son reconocidos en:

- Archivo CONTRIBUTORS.md
- Release notes
- README (contribuidores principales)

## 📞 Contacto

- **Issues**: GitHub Issues
- **Discusiones**: GitHub Discussions
- **Email**: [correo del proyecto]

## 📜 Licencia

Al contribuir, aceptas que tus contribuciones serán licenciadas bajo la misma licencia MIT del proyecto.

---

## 🙏 Gracias

¡Gracias por considerar contribuir a DESBLOCK-NET! Cada contribución, grande o pequeña, es valiosa y apreciada.

**Juntos hacemos mejor software para la comunidad educativa argentina.** 🇦🇷

