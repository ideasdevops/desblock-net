# 📖 Manual de Usuario - DESBLOCK-NET

## Introducción

DESBLOCK-NET es un sistema diseñado para ayudar a desbloquear equipos del programa **Conectar Igualdad** entregados entre 2021 y 2023. Este manual te guiará paso a paso en el proceso de desbloqueo.

## 📋 Requisitos Previos

### Hardware Necesario
- ✅ Equipo bloqueado de Conectar Igualdad (2021-2023)
- ✅ USB de al menos 8 GB (vacío)
- ✅ Computadora para preparar el USB
- ✅ Conexión a Internet (para descargar Linux Mint)

### Información que Necesitarás
Cuando tu equipo está bloqueado, aparece una pantalla con dos datos importantes:
- **ID de Hardware** (Hardware ID)
- **Marca de Arranque** (Boot Mark)

📝 **Anota estos datos antes de continuar**

## 🚀 Guía Paso a Paso

### Paso 1: Preparar el USB Booteable

#### En Linux:

1. **Insertar el USB** en tu computadora

2. **Identificar el dispositivo USB:**
```bash
lsblk
```
Busca tu USB (por ejemplo: `/dev/sdb`)

3. **Ejecutar el script de creación:**
```bash
cd DESBLOCK-NET
sudo ./scripts/install_dependencies.sh
sudo ./scripts/create_bootable_usb.sh /dev/sdX
```
⚠️ Reemplaza `/dev/sdX` con tu dispositivo USB

4. **Esperar a que complete** (puede tardar 10-30 minutos)

#### En Windows:

1. Descargar [Rufus](https://rufus.ie/)
2. Descargar [Linux Mint ISO](https://linuxmint.com/download.php)
3. Abrir Rufus y configurar:
   - Dispositivo: Tu USB
   - Selección de arranque: Imagen ISO de Linux Mint
   - Esquema de partición: MBR
   - Sistema de destino: BIOS o UEFI
4. Hacer clic en "EMPEZAR"
5. Una vez completado, copiar la carpeta `src/` de DESBLOCK-NET al USB

### Paso 2: Arrancar desde el USB

1. **Insertar el USB** en el equipo bloqueado

2. **Reiniciar el equipo** y presionar una de estas teclas repetidamente:
   - `F12` (más común)
   - `F10`
   - `ESC`
   - `F2`

3. **Seleccionar el USB** del menú de arranque

4. **Esperar a que cargue Linux Mint** (selecciona "Start Linux Mint" si aparece un menú)

### Paso 3: Generar el Código de Desbloqueo

#### Usando la Interfaz Gráfica (Recomendado):

1. **Una vez en Linux Mint**, busca el ícono de DESBLOCK-NET en el escritorio

2. **Doble clic** para abrir la aplicación

3. **Seleccionar el año** de entrega de tu equipo (2021, 2022 o 2023)

4. **Ingresar los datos** que anotaste de la pantalla de bloqueo:
   - ID de Hardware
   - Marca de Arranque

5. **Hacer clic en "Generar Código"**

6. **Copiar el código** generado (botón "Copiar Código")

#### Usando Línea de Comandos:

1. **Abrir terminal** (Ctrl+Alt+T)

2. **Navegar al directorio:**
```bash
cd /media/*/desblock-net/src
```

3. **Ejecutar el generador:**
```bash
python3 unlock_generator.py \
  --year 2023 \
  --hardware-id "TU_HARDWARE_ID" \
  --boot-mark "TU_BOOT_MARK" \
  --save-log
```

4. **Copiar el código** mostrado

### Paso 4: Desbloquear el Equipo

1. **Apagar la computadora** (no reiniciar)

2. **Retirar el USB**

3. **Encender el equipo** normalmente

4. **En la pantalla de bloqueo**, ingresa el código generado

5. El equipo debería desbloquearse y continuar al sistema operativo

6. **IMPORTANTE**: Conecta el equipo a Internet inmediatamente para validar el desbloqueo

### Paso 5: Validación Final

Una vez desbloqueado y con Internet:

1. El equipo se conectará automáticamente a los servidores de Conectar Igualdad
2. Validará el desbloqueo
3. Extenderá el período de uso antes del próximo bloqueo

## ❓ Preguntas Frecuentes

### ¿El código es permanente?
No, el código es temporal. El equipo debe conectarse a Internet periódicamente para evitar un nuevo bloqueo.

### ¿Cuánto tiempo tengo antes de que se bloquee nuevamente?
Generalmente entre 30-90 días, dependiendo de la configuración del equipo.

### ¿Qué hago si el código no funciona?
1. Verifica que copiaste correctamente el ID de Hardware y Marca de Arranque
2. Asegúrate de seleccionar el año correcto (2021, 2022 o 2023)
3. Intenta generar un nuevo código
4. Si persiste el problema, contacta al soporte oficial de tu provincia

### ¿Necesito Internet para generar el código?
No, el código se genera localmente. Solo necesitas Internet para la validación final después de desbloquear.

### ¿Puedo usar el mismo USB para varios equipos?
Sí, el USB puede usarse para desbloquear múltiples equipos.

### ¿Es legal usar este sistema?
Este sistema replica el proceso oficial de desbloqueo. Se recomienda siempre intentar primero los canales oficiales de tu provincia.

## 🆘 Solución de Problemas

### El USB no arranca
- Verifica que el BIOS esté configurado para arrancar desde USB
- Intenta recrear el USB
- Prueba con otro puerto USB

### La aplicación no se abre
- Abre una terminal y ejecuta: `python3 /media/*/desblock-net/src/gui_app.py`
- Verifica que Python esté instalado: `python3 --version`

### El código generado no funciona
- Verifica los datos ingresados (sin espacios adicionales)
- Intenta con el año anterior/posterior si no estás seguro
- Contacta al soporte oficial

### El equipo se bloqueó nuevamente
- Genera un nuevo código (la Marca de Arranque cambia cada bloqueo)
- Asegúrate de conectar el equipo a Internet después de desbloquear

## 📞 Contactos Oficiales por Provincia

### Buenos Aires
- 🌐 https://abc.gob.ar/conectar-igualdad/desbloqueo
- 📧 soporte.ci@abc.gob.ar

### San Juan
- 🌐 https://turnos.sanjuan.gob.ar/
- 📍 9 de Julio 1515 este, Santa Lucía

### Neuquén
- 🌐 https://sites.google.com/view/desbloqueosneuquen/

### Otras Provincias
- 🌐 https://conectarigualdad.gob.ar/desbloqueo
- ☎️ 0800-333-CONECTAR
- 📧 soporte@conectarigualdad.gob.ar

## 💡 Consejos y Recomendaciones

1. **Mantén tu equipo conectado** a Internet regularmente
2. **Guarda el USB** en un lugar seguro para futuros desbloqueos
3. **Anota los códigos** generados para referencia futura
4. **Actualiza el sistema operativo** del equipo regularmente
5. **No intentes modificar** el sistema de bloqueo del equipo

## 🔐 Privacidad y Seguridad

- DESBLOCK-NET **no envía datos** a servidores externos
- Los códigos se generan **localmente** en tu computadora
- Los logs son **opcionales** y se guardan solo en tu USB
- No se almacenan **datos personales**

## 📝 Notas Adicionales

Este sistema está diseñado para:
- ✅ Estudiantes que perdieron acceso a sus equipos
- ✅ Docentes con problemas de conectividad
- ✅ Instituciones educativas sin acceso al soporte oficial
- ✅ Situaciones de emergencia donde el soporte oficial no está disponible

**Se recomienda siempre intentar primero el soporte oficial de tu provincia.**

---

**¿Necesitas más ayuda?** Consulta el [Manual Técnico](MANUAL_TECNICO.md) o las [Preguntas Frecuentes](FAQ.md)

