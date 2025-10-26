# DESBLOCK-NET - Sistema de Desbloqueo Conectar Igualdad

## 🎯 Descripción

Sistema Linux booteable desde USB diseñado para desbloquear laptops del programa **Conectar Igualdad** entregadas por el gobierno argentino entre 2021-2023.

## 📋 Información de los Equipos

### Modelos Afectados
- **Dell Vostro** (2021-2023)
- Procesador: Intel Celeron 5100
- RAM: 4 GB DDR4
- Almacenamiento: 120 GB SSD
- Sistema Operativo: Windows 11

### Sistema de Bloqueo
Los equipos cuentan con el sistema **"Theft Deterrent"** que requiere validación periódica con servidores del Ministerio de Educación. Si no se conectan regularmente, el equipo se bloquea.

#### Servidores según año de entrega:
- **2023**: `tds.educacion.gob.ar`
- **2021-2022** (Programa Juana Manso): `citd.dgp.educ.ar`

### Datos Necesarios para Desbloqueo
Cuando un equipo se bloquea, la pantalla muestra:
- **ID de Hardware** (Hardware ID)
- **Marca de Arranque** (Boot Mark)

## 🚀 Características del Sistema

1. **Linux Booteable**: Sistema basado en Linux Mint que se ejecuta desde USB
2. **Generador de Códigos**: Herramienta para generar códigos de desbloqueo
3. **Interfaz Gráfica**: Aplicación amigable para facilitar el proceso
4. **Portable**: No requiere instalación en el equipo bloqueado
5. **Persistente**: Guarda configuraciones y logs de desbloqueos realizados

## 📂 Estructura del Proyecto

```
DESBLOCK-NET/
├── README.md                          # Este archivo
├── docs/                              # Documentación
│   ├── MANUAL_USUARIO.md             # Manual para usuarios finales
│   ├── MANUAL_TECNICO.md             # Documentación técnica
│   └── FAQ.md                        # Preguntas frecuentes
├── src/                              # Código fuente
│   ├── unlock_generator.py           # Generador de códigos de desbloqueo
│   ├── gui_app.py                    # Interfaz gráfica
│   └── utils.py                      # Utilidades
├── scripts/                          # Scripts de automatización
│   ├── create_bootable_usb.sh        # Crea el USB booteable
│   ├── customize_iso.sh              # Personaliza la ISO de Linux Mint
│   └── install_dependencies.sh       # Instala dependencias
├── config/                           # Archivos de configuración
│   ├── servers.json                  # Lista de servidores de desbloqueo
│   └── settings.json                 # Configuración general
└── requirements.txt                  # Dependencias Python
```

## 🔧 Instalación

### Requisitos Previos
- USB de al menos 8 GB
- Conexión a Internet
- Linux (recomendado) o Windows con WSL

### Paso 1: Clonar el Repositorio
```bash
git clone https://github.com/tu-usuario/DESBLOCK-NET.git
cd DESBLOCK-NET
```

### Paso 2: Instalar Dependencias
```bash
chmod +x scripts/install_dependencies.sh
./scripts/install_dependencies.sh
```

### Paso 3: Crear USB Booteable
```bash
# Identifica tu USB (ej: /dev/sdb)
lsblk

# Crea el USB booteable
sudo ./scripts/create_bootable_usb.sh /dev/sdX
```
**⚠️ ADVERTENCIA**: Reemplaza `/dev/sdX` con tu dispositivo USB. Este proceso borrará todos los datos del USB.

## 📖 Uso

### 1. Arrancar desde USB
1. Inserta el USB en el equipo bloqueado
2. Reinicia el equipo
3. Presiona F12 / F10 / ESC para acceder al menú de arranque
4. Selecciona el USB como dispositivo de arranque

### 2. Ejecutar el Desbloqueador
Una vez iniciado Linux Mint desde el USB:
1. Abre la aplicación "DESBLOCK-NET" desde el escritorio
2. Selecciona el año de entrega del equipo (2021, 2022 o 2023)
3. Ingresa el **ID de Hardware** y la **Marca de Arranque**
4. Haz clic en "Generar Código"
5. Copia el código generado
6. Reinicia el equipo y sigue el proceso de desbloqueo normal

### 3. Aplicar el Código de Desbloqueo
1. En la pantalla de bloqueo del equipo
2. Ingresa el código generado
3. Conecta el equipo a Internet
4. El sistema validará y extenderá el período de uso

## ⚖️ Consideraciones Legales y Éticas

### ⚠️ IMPORTANTE
Este proyecto tiene fines **EDUCATIVOS y de ASISTENCIA TÉCNICA** para:
- Estudiantes que perdieron acceso a sus equipos asignados
- Docentes con equipos bloqueados por falta de conectividad
- Instituciones educativas con problemas de soporte técnico

### Legalidad
- Los equipos son propiedad del Estado Argentino
- El programa tiene procedimientos oficiales de desbloqueo
- Este sistema NO evita medidas de seguridad, sino que replica el proceso oficial
- Se recomienda siempre intentar primero los canales oficiales

### Canales Oficiales por Provincia
- **Buenos Aires**: Formulario online oficial
- **San Juan**: Turnos en https://turnos.sanjuan.gob.ar/
- **Neuquén**: https://sites.google.com/view/desbloqueosneuquen/

## 🔒 Seguridad

- Los códigos generados son temporales
- Se requiere conexión a Internet para validación final
- No se almacenan datos personales
- Todos los logs son locales y opcionales

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Haz un Fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agrega nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo licencia MIT. Ver archivo `LICENSE` para más detalles.

## 📞 Soporte y Contacto

Para problemas, sugerencias o consultas:
- Abre un Issue en GitHub
- Contacta al equipo de desarrollo

## 🙏 Agradecimientos

- Comunidad de software libre Argentina
- Programa Conectar Igualdad
- Comunidad de usuarios que aportan información técnica

---

**Desarrollado con ❤️ por IdeasDevOps para ayudar a la comunidad educativa argentina**

