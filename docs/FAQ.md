# ❓ Preguntas Frecuentes (FAQ) - DESBLOCK-NET

## Índice
- [Preguntas Generales](#preguntas-generales)
- [Uso del Sistema](#uso-del-sistema)
- [Problemas Técnicos](#problemas-técnicos)
- [Legalidad y Ética](#legalidad-y-ética)
- [Soporte y Ayuda](#soporte-y-ayuda)

---

## Preguntas Generales

### ¿Qué es DESBLOCK-NET?

DESBLOCK-NET es un sistema de código abierto diseñado para ayudar a desbloquear equipos del programa Conectar Igualdad (2021-2023) que se han bloqueado por falta de conexión a los servidores del Ministerio de Educación.

### ¿Para qué equipos funciona?

Funciona para:
- ✅ Netbooks y laptops de Conectar Igualdad entregadas en **2021**
- ✅ Equipos del Programa Juana Manso entregados en **2022**
- ✅ Laptops de Conectar Igualdad entregadas en **2023**

### ¿Cómo sé de qué año es mi equipo?

Generalmente hay una etiqueta en la parte inferior del equipo o puedes verificar con tu institución educativa. Si no estás seguro, puedes probar con diferentes años en DESBLOCK-NET.

### ¿Es gratis?

Sí, DESBLOCK-NET es completamente gratuito y de código abierto bajo licencia MIT.

### ¿Funciona en cualquier computadora?

El sistema se ejecuta desde un USB booteable con Linux Mint, por lo que es compatible con prácticamente cualquier PC moderna (x86/x64).

---

## Uso del Sistema

### ¿Qué necesito para usar DESBLOCK-NET?

Necesitas:
1. Un USB de al menos 8 GB (vacío)
2. Una computadora para preparar el USB
3. Conexión a Internet (para descargar Linux Mint)
4. Los datos de tu equipo bloqueado (Hardware ID y Boot Mark)

### ¿Cuánto tarda el proceso completo?

- **Preparar USB**: 15-30 minutos (dependiendo de tu Internet)
- **Arrancar desde USB**: 2-5 minutos
- **Generar código**: 10 segundos
- **Desbloquear equipo**: 1-2 minutos

**Total**: Aproximadamente 20-40 minutos

### ¿Necesito conocimientos técnicos?

No necesariamente. El proceso está diseñado para ser simple:
- Si sabes copiar archivos y seguir instrucciones, puedes usar la versión básica
- Si tienes conocimientos de Linux, puedes usar funciones avanzadas

### ¿Puedo usar el mismo USB para varios equipos?

Sí, una vez creado el USB booteable, puedes usarlo para desbloquear múltiples equipos.

### ¿El código es permanente?

**No.** El código desbloquea el equipo temporalmente. El equipo debe conectarse a Internet periódicamente para validar y extender el período de uso.

### ¿Cuánto tiempo dura el desbloqueo?

Generalmente entre **30 a 90 días**, dependiendo de la configuración del equipo. Después de ese tiempo, necesitarás generar un nuevo código.

### ¿Qué hago si no tengo Internet?

- **Para generar el código**: No necesitas Internet (se hace localmente)
- **Para la validación final**: Sí necesitas conectar el equipo a Internet después de desbloquearlo

---

## Problemas Técnicos

### El USB no arranca, ¿qué hago?

**Posibles soluciones:**

1. **Verifica el orden de arranque en BIOS:**
   - Reinicia y presiona F2/F10/DEL
   - Ve a "Boot Order" o "Orden de arranque"
   - Coloca USB como primera opción

2. **Verifica el modo de arranque:**
   - Secure Boot: **Deshabilitado**
   - Boot Mode: Prueba con **Legacy** y **UEFI**

3. **Prueba otro puerto USB:**
   - Usa puertos USB 2.0 (no siempre 3.0 funciona)
   - Evita hubs USB

4. **Recrea el USB:**
   - Puede haberse corrompido durante la creación

### La aplicación no se abre en Linux Mint

**Solución:**

```bash
# Abrir terminal (Ctrl+Alt+T)
cd /media/*/desblock-net/src
python3 gui_app.py
```

Si aparece error de Python:
```bash
sudo apt install python3 python3-tk
```

### El código generado no funciona

**Posibles causas:**

1. **Año incorrecto:**
   - Verifica el año de entrega del equipo
   - Prueba con años adyacentes si no estás seguro

2. **Datos mal copiados:**
   - Verifica que no haya espacios adicionales
   - Asegúrate de copiar exactamente como aparece
   - Los caracteres similares: O (letra) vs 0 (cero), l (ele) vs 1 (uno)

3. **Boot Mark cambió:**
   - La Boot Mark cambia cada vez que se bloquea
   - Debes usar los datos actuales de la pantalla de bloqueo

4. **Equipo con bloqueo diferente:**
   - Algunos equipos pueden tener versiones diferentes del sistema

### ¿Puedo usar Windows en lugar de Linux?

El sistema está diseñado para Linux, pero puedes:

1. **Usar WSL (Windows Subsystem for Linux):**
```bash
wsl --install
# Luego instala Python y ejecuta los scripts
```

2. **Usar Python en Windows:**
   - Instala Python 3 para Windows
   - Ejecuta directamente `python unlock_generator.py`

3. **Usar el USB booteable:**
   - Esta es la opción más confiable

### Mi USB se borró accidentalmente

Si creaste el USB booteable, el contenido original se sobreescribió. **No es recuperable**.

Por eso recomendamos usar un USB vacío o hacer backup antes.

### El equipo se volvió a bloquear

**Es normal.** El bloqueo es periódico. Solución:

1. Genera un nuevo código (la Boot Mark será diferente)
2. Desbloquea nuevamente
3. **Importante**: Conecta el equipo a Internet para extender el período

**Prevención:**
- Conecta el equipo a Internet regularmente
- Configura actualizaciones automáticas

---

## Legalidad y Ética

### ¿Es legal usar DESBLOCK-NET?

**Sí**, siempre que:
- ✅ El equipo te fue asignado legítimamente
- ✅ No lo estés usando para fines ilícitos
- ✅ Eres estudiante, docente o parte de institución educativa

**No es legal si:**
- ❌ El equipo es robado
- ❌ No eres el beneficiario legítimo
- ❌ Lo usas para eludir restricciones de manera fraudulenta

### ¿Por qué no usar los canales oficiales?

**Deberías intentar primero los canales oficiales**, pero DESBLOCK-NET es útil cuando:

- No hay respuesta del soporte oficial
- Tu provincia no tiene sistema de desbloqueo en línea
- Es urgente y necesitas acceso inmediato para estudiar
- El soporte oficial está saturado

### ¿Esto viola alguna ley?

No. DESBLOCK-NET **replica el proceso oficial** de desbloqueo. No evita medidas de seguridad, simplemente facilita el acceso al proceso legítimo.

**Nota legal**: Este software se proporciona "tal cual", sin garantías. El uso es bajo tu propia responsabilidad.

### ¿Puedo modificar y redistribuir DESBLOCK-NET?

Sí, bajo los términos de la licencia MIT:
- ✅ Puedes modificar el código
- ✅ Puedes redistribuirlo
- ✅ Puedes usarlo comercialmente
- ⚠️ Debes incluir el aviso de copyright original
- ⚠️ Es sin garantía

### ¿Los códigos generados son los mismos que los oficiales?

Los códigos son generados mediante algoritmos basados en ingeniería inversa del sistema oficial. **Funcionan de la misma manera**, pero no provienen de los servidores oficiales.

---

## Soporte y Ayuda

### ¿Dónde puedo conseguir ayuda?

1. **Documentación:**
   - [Manual de Usuario](MANUAL_USUARIO.md)
   - [Manual Técnico](MANUAL_TECNICO.md)
   - Este FAQ

2. **GitHub:**
   - Abre un Issue para reportar problemas
   - Revisa Issues existentes

3. **Soporte Oficial por Provincia:**
   - [Buenos Aires](https://abc.gob.ar/conectar-igualdad/)
   - [San Juan](https://turnos.sanjuan.gob.ar/)
   - [Neuquén](https://sites.google.com/view/desbloqueosneuquen/)
   - Línea Nacional: 0800-333-CONECTAR

### ¿Cómo reporto un bug?

1. Ve a la página de [Issues en GitHub](https://github.com/tu-usuario/DESBLOCK-NET/issues)
2. Crea un nuevo Issue
3. Incluye:
   - Descripción del problema
   - Pasos para reproducirlo
   - Año del equipo
   - Logs (si los tienes)
   - Screenshots (si aplica)

### ¿Puedo contribuir al proyecto?

¡Por supuesto! Las contribuciones son bienvenidas:

- 🐛 Reporta bugs
- 💡 Sugiere mejoras
- 🔧 Envía Pull Requests
- 📝 Mejora la documentación
- 🌍 Traduce a otros idiomas
- ⭐ Dale una estrella en GitHub

### ¿Hay una versión móvil?

Actualmente no. DESBLOCK-NET está diseñado para ejecutarse en computadoras de escritorio/laptop con Linux.

Una versión móvil podría ser posible en el futuro como app Android/iOS, pero requeriría:
- Interfaz adaptada
- Generador de códigos portable
- Método alternativo de aplicación (sin USB booteable)

### ¿Hay soporte para otros programas similares?

DESBLOCK-NET está específicamente diseñado para **Conectar Igualdad Argentina (2021-2023)**.

Para otros programas:
- **Ceibal (Uruguay)**: Sistema diferente, no compatible
- **Primaria Digital (Argentina, anterior a 2020)**: Sistema antiguo, podría adaptarse
- **Otros países**: Requerirían análisis y adaptación del código

---

## Casos de Uso Específicos

### Soy docente, ¿puedo usar esto en mi escuela?

Sí, DESBLOCK-NET es ideal para:
- Desbloquear equipos de estudiantes con problemas
- Situaciones de emergencia donde se necesita acceso inmediato
- Escuelas en zonas con conectividad limitada
- Como respaldo al soporte oficial

**Recomendación**: Mantén un registro de los equipos desbloqueados.

### Soy técnico de una institución, ¿cómo lo integro?

Opciones:

1. **Script batch para múltiples equipos:**
```python
# desbloquear_batch.py
from src.unlock_generator import UnlockCodeGenerator

equipos = [
    ("HW_ID_1", "BOOT_MARK_1", "2023"),
    ("HW_ID_2", "BOOT_MARK_2", "2022"),
]

for hw, bm, year in equipos:
    gen = UnlockCodeGenerator(year=year)
    success, msg, code = gen.generate_unlock_code(hw, bm)
    if success:
        print(f"{hw}: {code}")
```

2. **Crear múltiples USBs:**
   - Crea varios USBs booteables
   - Distribúyelos a técnicos

3. **Servidor interno:**
   - Monta un servidor con la API
   - Acceso desde navegador web

### El equipo tiene otros problemas además del bloqueo

DESBLOCK-NET **solo** desbloquea el sistema de "Theft Deterrent". No soluciona:

- ❌ Problemas de hardware (pantalla, teclado, etc.)
- ❌ Virus o malware
- ❌ Windows corrupto
- ❌ Contraseñas olvidadas de usuario
- ❌ Bloqueo de BIOS

Para esos casos, consulta al soporte técnico oficial.

---

## Preguntas Avanzadas

### ¿Puedo ejecutar DESBLOCK-NET sin GUI?

Sí, usa la línea de comandos:

```bash
python3 unlock_generator.py \
    --year 2023 \
    --hardware-id "TU_HW_ID" \
    --boot-mark "TU_BOOT_MARK"
```

### ¿Puedo automatizar el proceso?

Sí, DESBLOCK-NET es completamente scriptable. Ver [Manual Técnico](MANUAL_TECNICO.md) para ejemplos de automatización.

### ¿Los logs son necesarios?

No, son opcionales. Los logs:
- ✅ Te ayudan a llevar registro
- ✅ Útiles para depuración
- ✅ Solo guardan los últimos 4 caracteres (privacidad)
- ❌ No son enviados a ningún servidor

### ¿Puedo cambiar los algoritmos?

Sí, el código es abierto. Puedes:
- Modificar los algoritmos
- Agregar soporte para otros años
- Mejorar la seguridad
- Optimizar el rendimiento

**Nota**: Si cambias los algoritmos, los códigos generados serán diferentes.

### ¿Funciona en ARM (Raspberry Pi)?

El código Python sí es compatible, pero:
- ❌ El USB booteable de Linux Mint es x86/x64 únicamente
- ✅ Puedes ejecutar el generador de códigos en Raspberry Pi
- ✅ Útil para crear un servidor de desbloqueo

---

## Glosario

| Término | Definición |
|---------|------------|
| **Hardware ID** | Identificador único del hardware del equipo |
| **Boot Mark** | Marca temporal de arranque que cambia con cada bloqueo |
| **Theft Deterrent** | Sistema anti-robo que bloquea el equipo periódicamente |
| **CITD** | Centro de Innovación y Tecnología para el Desarrollo (servidor 2021-2022) |
| **TDS** | Theft Deterrent System (servidor 2023) |
| **Live USB** | USB que arranca un sistema operativo sin instalarlo |
| **ISO** | Imagen de disco óptico (formato de archivo de Linux Mint) |

---

## Recursos Adicionales

### Tutoriales en Video
(Pendiente - Contribuciones bienvenidas)

### Comunidad
- GitHub Discussions
- Foros de soporte
- Grupos de Telegram/WhatsApp (comunitarios)

### Enlaces Oficiales
- [Conectar Igualdad](https://conectarigualdad.gob.ar/)
- [Ministerio de Educación](https://www.argentina.gob.ar/educacion)

---

**¿Tu pregunta no está aquí?**

1. Abre un [Issue en GitHub](https://github.com/tu-usuario/DESBLOCK-NET/issues)
2. Consulta los [Manuales](README.md)
3. Contacta al soporte oficial de tu provincia

---

**Última actualización**: 2024-10-26  
**Versión**: 1.0.0

