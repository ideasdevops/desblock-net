# 🚀 Inicio Rápido - DESBLOCK-NET

## ⚡ Para Usuarios (Modo Rápido)

### 1. Preparar USB Booteable

```bash
# En Linux:
sudo ./scripts/install_dependencies.sh
sudo ./scripts/create_bootable_usb.sh /dev/sdX
```

### 2. Arrancar desde USB

1. Insertar USB en equipo bloqueado
2. Presionar F12/F10/ESC durante el arranque
3. Seleccionar USB

### 3. Generar Código

1. Abrir aplicación "DESBLOCK-NET" desde escritorio
2. Seleccionar año del equipo
3. Ingresar Hardware ID y Boot Mark
4. Copiar código generado

### 4. Desbloquear

1. Reiniciar equipo sin USB
2. Ingresar código en pantalla de bloqueo
3. Conectar a Internet

---

## 🔧 Para Técnicos (Línea de Comandos)

```bash
# Generar código directamente
python3 src/unlock_generator.py \
    --year 2023 \
    --hardware-id "ABC123DEF456" \
    --boot-mark "987654321" \
    --save-log

# Múltiples equipos con script
python3 << EOF
from src.unlock_generator import UnlockCodeGenerator

equipos = [
    ("HW_ID_1", "BOOT_MARK_1", "2023"),
    ("HW_ID_2", "BOOT_MARK_2", "2022"),
]

for hw, bm, year in equipos:
    gen = UnlockCodeGenerator(year=year)
    success, msg, code = gen.generate_unlock_code(hw, bm)
    if success:
        print(f"{hw[-4:]}: {code}")
EOF
```

---

## 📚 Documentación Completa

- [Manual de Usuario](docs/MANUAL_USUARIO.md) - Guía detallada paso a paso
- [Manual Técnico](docs/MANUAL_TECNICO.md) - Documentación técnica completa
- [FAQ](docs/FAQ.md) - Preguntas frecuentes
- [README](README.md) - Documentación principal

---

## 🆘 Problemas Comunes

### USB no arranca
```bash
# Verificar BIOS:
# - Secure Boot: Deshabilitado
# - Boot Mode: Legacy/UEFI
# - USB como primera opción
```

### Python no funciona
```bash
sudo apt install python3 python3-tk
python3 --version  # Debe ser 3.6+
```

### Código no funciona
- Verifica el año del equipo (2021, 2022 o 2023)
- Copia exactamente Hardware ID y Boot Mark
- Sin espacios adicionales

---

## 📞 Soporte

**Canales Oficiales por Provincia:**

- Buenos Aires: https://abc.gob.ar/conectar-igualdad/desbloqueo
- San Juan: https://turnos.sanjuan.gob.ar/
- Neuquén: https://sites.google.com/view/desbloqueosneuquen/
- Nacional: 0800-333-CONECTAR

**Soporte del Proyecto:**
- GitHub Issues: Reporta problemas técnicos
- Documentación: Lee los manuales completos

---

## ⚖️ Importante

- ✅ Solo para equipos legítimamente asignados
- ✅ Intenta primero canales oficiales
- ✅ El código es temporal
- ✅ Conecta a Internet después de desbloquear

---

**¿Primera vez?** → Lee el [Manual de Usuario](docs/MANUAL_USUARIO.md)  
**¿Desarrollador?** → Lee el [Manual Técnico](docs/MANUAL_TECNICO.md)  
**¿Dudas?** → Consulta el [FAQ](docs/FAQ.md)

