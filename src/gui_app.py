#!/usr/bin/env python3
"""
DESBLOCK-NET - Interfaz Gráfica
Aplicación GUI para desbloqueo de equipos Conectar Igualdad
"""

import sys
import os
from datetime import datetime
from pathlib import Path

try:
    import tkinter as tk
    from tkinter import ttk, messagebox, scrolledtext
except ImportError:
    print("Error: tkinter no está instalado")
    sys.exit(1)

# Importar el generador de códigos
try:
    from unlock_generator import UnlockCodeGenerator
except ImportError:
    # Si falla, intentar desde el mismo directorio
    import sys
    sys.path.insert(0, os.path.dirname(__file__))
    from unlock_generator import UnlockCodeGenerator


class DesblockNetGUI:
    """
    Interfaz gráfica para el sistema de desbloqueo DESBLOCK-NET.
    """
    
    def __init__(self, root):
        self.root = root
        self.root.title("DESBLOCK-NET - Desbloqueador Conectar Igualdad")
        self.root.geometry("700x650")
        self.root.resizable(False, False)
        
        # Variables
        self.year_var = tk.StringVar(value="2023")
        self.hardware_id_var = tk.StringVar()
        self.boot_mark_var = tk.StringVar()
        self.save_log_var = tk.BooleanVar(value=True)
        
        # Generador (se actualizará según el año seleccionado)
        self.generator = UnlockCodeGenerator(year="2023")
        
        # Configurar estilo
        self.setup_styles()
        
        # Crear interfaz
        self.create_header()
        self.create_info_section()
        self.create_input_section()
        self.create_output_section()
        self.create_footer()
        
        # Actualizar información del servidor
        self.update_server_info()
    
    def setup_styles(self):
        """Configura los estilos de la aplicación."""
        style = ttk.Style()
        style.theme_use('clam')
        
        # Colores
        self.bg_color = "#2c3e50"
        self.fg_color = "#ecf0f1"
        self.accent_color = "#3498db"
        self.success_color = "#27ae60"
        self.error_color = "#e74c3c"
        
        # Configurar root
        self.root.configure(bg=self.bg_color)
    
    def create_header(self):
        """Crea la sección de encabezado."""
        header_frame = tk.Frame(self.root, bg=self.accent_color, height=80)
        header_frame.pack(fill=tk.X, padx=0, pady=0)
        header_frame.pack_propagate(False)
        
        # Título
        title_label = tk.Label(
            header_frame,
            text="🔓 DESBLOCK-NET",
            font=("Arial", 24, "bold"),
            bg=self.accent_color,
            fg="white"
        )
        title_label.pack(pady=5)
        
        # Subtítulo
        subtitle_label = tk.Label(
            header_frame,
            text="Sistema de Desbloqueo - Conectar Igualdad 2021-2023",
            font=("Arial", 11),
            bg=self.accent_color,
            fg="white"
        )
        subtitle_label.pack()
    
    def create_info_section(self):
        """Crea la sección de información del servidor."""
        info_frame = tk.LabelFrame(
            self.root,
            text="📡 Información del Sistema",
            font=("Arial", 10, "bold"),
            bg=self.bg_color,
            fg=self.fg_color,
            padx=15,
            pady=10
        )
        info_frame.pack(fill=tk.X, padx=20, pady=10)
        
        # Frame interno
        inner_frame = tk.Frame(info_frame, bg=self.bg_color)
        inner_frame.pack(fill=tk.X)
        
        # Año de entrega
        year_frame = tk.Frame(inner_frame, bg=self.bg_color)
        year_frame.pack(fill=tk.X, pady=5)
        
        tk.Label(
            year_frame,
            text="Año de entrega del equipo:",
            font=("Arial", 10, "bold"),
            bg=self.bg_color,
            fg=self.fg_color
        ).pack(side=tk.LEFT, padx=(0, 10))
        
        for year in ["2021", "2022", "2023"]:
            rb = tk.Radiobutton(
                year_frame,
                text=year,
                variable=self.year_var,
                value=year,
                font=("Arial", 10),
                bg=self.bg_color,
                fg=self.fg_color,
                selectcolor=self.accent_color,
                activebackground=self.bg_color,
                activeforeground=self.fg_color,
                command=self.update_server_info
            )
            rb.pack(side=tk.LEFT, padx=5)
        
        # Información del servidor
        self.server_info_label = tk.Label(
            inner_frame,
            text="",
            font=("Arial", 9),
            bg=self.bg_color,
            fg=self.accent_color,
            justify=tk.LEFT
        )
        self.server_info_label.pack(fill=tk.X, pady=5)
    
    def create_input_section(self):
        """Crea la sección de entrada de datos."""
        input_frame = tk.LabelFrame(
            self.root,
            text="📝 Datos del Equipo Bloqueado",
            font=("Arial", 10, "bold"),
            bg=self.bg_color,
            fg=self.fg_color,
            padx=15,
            pady=10
        )
        input_frame.pack(fill=tk.X, padx=20, pady=10)
        
        # Hardware ID
        hw_frame = tk.Frame(input_frame, bg=self.bg_color)
        hw_frame.pack(fill=tk.X, pady=5)
        
        tk.Label(
            hw_frame,
            text="ID de Hardware:",
            font=("Arial", 10, "bold"),
            bg=self.bg_color,
            fg=self.fg_color,
            width=20,
            anchor='w'
        ).pack(side=tk.LEFT)
        
        hw_entry = tk.Entry(
            hw_frame,
            textvariable=self.hardware_id_var,
            font=("Courier", 11),
            bg="#34495e",
            fg="white",
            insertbackground="white",
            relief=tk.FLAT,
            width=40
        )
        hw_entry.pack(side=tk.LEFT, padx=10, ipady=5)
        
        # Boot Mark
        bm_frame = tk.Frame(input_frame, bg=self.bg_color)
        bm_frame.pack(fill=tk.X, pady=5)
        
        tk.Label(
            bm_frame,
            text="Marca de Arranque:",
            font=("Arial", 10, "bold"),
            bg=self.bg_color,
            fg=self.fg_color,
            width=20,
            anchor='w'
        ).pack(side=tk.LEFT)
        
        bm_entry = tk.Entry(
            bm_frame,
            textvariable=self.boot_mark_var,
            font=("Courier", 11),
            bg="#34495e",
            fg="white",
            insertbackground="white",
            relief=tk.FLAT,
            width=40
        )
        bm_entry.pack(side=tk.LEFT, padx=10, ipady=5)
        
        # Ayuda
        help_text = tk.Label(
            input_frame,
            text="💡 Estos datos aparecen en la pantalla de bloqueo del equipo",
            font=("Arial", 9, "italic"),
            bg=self.bg_color,
            fg="#95a5a6"
        )
        help_text.pack(pady=5)
        
        # Checkbox para guardar log
        log_check = tk.Checkbutton(
            input_frame,
            text="Guardar registro del desbloqueo (recomendado)",
            variable=self.save_log_var,
            font=("Arial", 9),
            bg=self.bg_color,
            fg=self.fg_color,
            selectcolor=self.accent_color,
            activebackground=self.bg_color,
            activeforeground=self.fg_color
        )
        log_check.pack(pady=5)
        
        # Botón generar
        generate_btn = tk.Button(
            input_frame,
            text="🔑 GENERAR CÓDIGO DE DESBLOQUEO",
            font=("Arial", 12, "bold"),
            bg=self.success_color,
            fg="white",
            activebackground="#229954",
            activeforeground="white",
            relief=tk.FLAT,
            cursor="hand2",
            command=self.generate_code
        )
        generate_btn.pack(pady=15, ipady=10, ipadx=20)
    
    def create_output_section(self):
        """Crea la sección de salida de resultados."""
        output_frame = tk.LabelFrame(
            self.root,
            text="🔑 Código de Desbloqueo",
            font=("Arial", 10, "bold"),
            bg=self.bg_color,
            fg=self.fg_color,
            padx=15,
            pady=10
        )
        output_frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=10)
        
        # Área de texto para el resultado
        self.output_text = scrolledtext.ScrolledText(
            output_frame,
            font=("Courier", 11),
            bg="#34495e",
            fg="white",
            insertbackground="white",
            relief=tk.FLAT,
            height=8,
            wrap=tk.WORD
        )
        self.output_text.pack(fill=tk.BOTH, expand=True)
        
        # Mensaje inicial
        self.output_text.insert(1.0, "Ingrese los datos del equipo y haga clic en 'Generar Código'")
        self.output_text.config(state=tk.DISABLED)
        
        # Botones de acción
        button_frame = tk.Frame(output_frame, bg=self.bg_color)
        button_frame.pack(fill=tk.X, pady=10)
        
        copy_btn = tk.Button(
            button_frame,
            text="📋 Copiar Código",
            font=("Arial", 10),
            bg=self.accent_color,
            fg="white",
            activebackground="#2980b9",
            activeforeground="white",
            relief=tk.FLAT,
            cursor="hand2",
            command=self.copy_code
        )
        copy_btn.pack(side=tk.LEFT, padx=5)
        
        clear_btn = tk.Button(
            button_frame,
            text="🗑️ Limpiar",
            font=("Arial", 10),
            bg="#7f8c8d",
            fg="white",
            activebackground="#616a6b",
            activeforeground="white",
            relief=tk.FLAT,
            cursor="hand2",
            command=self.clear_fields
        )
        clear_btn.pack(side=tk.LEFT, padx=5)
    
    def create_footer(self):
        """Crea el pie de página."""
        footer_frame = tk.Frame(self.root, bg=self.bg_color, height=40)
        footer_frame.pack(fill=tk.X, side=tk.BOTTOM)
        footer_frame.pack_propagate(False)
        
        footer_label = tk.Label(
            footer_frame,
            text="© 2024 DESBLOCK-NET | Desarrollado para la comunidad educativa argentina",
            font=("Arial", 9),
            bg=self.bg_color,
            fg="#95a5a6"
        )
        footer_label.pack(pady=10)
    
    def update_server_info(self):
        """Actualiza la información del servidor según el año seleccionado."""
        year = self.year_var.get()
        self.generator = UnlockCodeGenerator(year=year)
        info = self.generator.get_info()
        
        info_text = f"Sistema: {info['server_name']}\n"
        info_text += f"Servidor: {info['server_url']} | Versión: {info['version']}"
        
        self.server_info_label.config(text=info_text)
    
    def generate_code(self):
        """Genera el código de desbloqueo."""
        hardware_id = self.hardware_id_var.get().strip()
        boot_mark = self.boot_mark_var.get().strip()
        
        # Validar que los campos no estén vacíos
        if not hardware_id or not boot_mark:
            messagebox.showerror(
                "Error",
                "Por favor complete todos los campos"
            )
            return
        
        # Generar código
        success, message, code = self.generator.generate_unlock_code(hardware_id, boot_mark)
        
        # Mostrar resultado
        self.output_text.config(state=tk.NORMAL)
        self.output_text.delete(1.0, tk.END)
        
        if success:
            # Guardar código para copiar
            self.last_generated_code = code
            
            # Formatear salida
            output = f"{'='*60}\n"
            output += f"✓ CÓDIGO GENERADO EXITOSAMENTE\n"
            output += f"{'='*60}\n\n"
            output += f"🔑 CÓDIGO DE DESBLOQUEO:\n\n"
            output += f"    {code}\n\n"
            output += f"{'='*60}\n\n"
            output += f"📋 INSTRUCCIONES:\n\n"
            output += f"1. Copie el código de desbloqueo\n"
            output += f"2. Reinicie el equipo bloqueado\n"
            output += f"3. Ingrese el código en la pantalla de bloqueo\n"
            output += f"4. Conecte el equipo a Internet para validación\n\n"
            output += f"⚠️  IMPORTANTE: El código es temporal. Debe conectar\n"
            output += f"   el equipo a Internet después de desbloquearlo.\n\n"
            output += f"Generado: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n"
            
            self.output_text.insert(1.0, output)
            
            # Guardar log si está habilitado
            if self.save_log_var.get():
                log_dir = os.path.join(os.path.expanduser("~"), "desblock-net-logs")
                self.generator.save_unlock_log(hardware_id, boot_mark, code, log_dir)
            
            # Mostrar mensaje de éxito
            messagebox.showinfo("Éxito", message)
            
        else:
            output = f"{'='*60}\n"
            output += f"✗ ERROR\n"
            output += f"{'='*60}\n\n"
            output += f"{message}\n\n"
            output += f"Por favor verifique los datos ingresados.\n"
            
            self.output_text.insert(1.0, output)
            messagebox.showerror("Error", message)
        
        self.output_text.config(state=tk.DISABLED)
    
    def copy_code(self):
        """Copia el código generado al portapapeles."""
        if hasattr(self, 'last_generated_code'):
            self.root.clipboard_clear()
            self.root.clipboard_append(self.last_generated_code)
            messagebox.showinfo("Copiado", "Código copiado al portapapeles")
        else:
            messagebox.showwarning("Advertencia", "No hay código para copiar")
    
    def clear_fields(self):
        """Limpia todos los campos."""
        self.hardware_id_var.set("")
        self.boot_mark_var.set("")
        
        self.output_text.config(state=tk.NORMAL)
        self.output_text.delete(1.0, tk.END)
        self.output_text.insert(1.0, "Ingrese los datos del equipo y haga clic en 'Generar Código'")
        self.output_text.config(state=tk.DISABLED)
        
        if hasattr(self, 'last_generated_code'):
            delattr(self, 'last_generated_code')


def main():
    """Función principal."""
    root = tk.Tk()
    app = DesblockNetGUI(root)
    root.mainloop()


if __name__ == "__main__":
    main()

