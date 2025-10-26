#!/usr/bin/env python3
"""
DESBLOCK-NET - Tests del Generador
Tests básicos para verificar el funcionamiento del generador de códigos
"""

import sys
import os

# Agregar src al path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from unlock_generator import UnlockCodeGenerator


def test_generator_instantiation():
    """Test: Crear instancia del generador"""
    print("Test 1: Instanciación del generador...")
    
    try:
        gen_2021 = UnlockCodeGenerator(year="2021")
        gen_2022 = UnlockCodeGenerator(year="2022")
        gen_2023 = UnlockCodeGenerator(year="2023")
        
        assert gen_2021.year == "2021"
        assert gen_2022.year == "2022"
        assert gen_2023.year == "2023"
        
        print("  ✓ OK: Instancias creadas correctamente")
        return True
    except Exception as e:
        print(f"  ✗ FAIL: {e}")
        return False


def test_invalid_year():
    """Test: Año inválido debe lanzar error"""
    print("Test 2: Validación de año inválido...")
    
    try:
        gen = UnlockCodeGenerator(year="2020")
        print("  ✗ FAIL: Debería haber lanzado excepción")
        return False
    except ValueError:
        print("  ✓ OK: Excepción lanzada correctamente")
        return True
    except Exception as e:
        print(f"  ✗ FAIL: Excepción incorrecta: {e}")
        return False


def test_hardware_id_validation():
    """Test: Validación de Hardware ID"""
    print("Test 3: Validación de Hardware ID...")
    
    gen = UnlockCodeGenerator(year="2023")
    
    # Casos válidos
    valid_ids = [
        "ABC123DEF456",
        "12345678",
        "ABCDEFGH",
        "ABC-123-DEF",
        "ABC_123_DEF"
    ]
    
    # Casos inválidos
    invalid_ids = [
        "",
        "ABC",  # Muy corto
        "A" * 40,  # Muy largo
        "ABC 123",  # Espacios no permitidos en validación
    ]
    
    all_passed = True
    
    for hw_id in valid_ids:
        if not gen.validate_hardware_id(hw_id):
            print(f"  ✗ FAIL: '{hw_id}' debería ser válido")
            all_passed = False
    
    for hw_id in invalid_ids:
        if gen.validate_hardware_id(hw_id):
            print(f"  ✗ FAIL: '{hw_id}' debería ser inválido")
            all_passed = False
    
    if all_passed:
        print("  ✓ OK: Validación de Hardware ID correcta")
    
    return all_passed


def test_boot_mark_validation():
    """Test: Validación de Boot Mark"""
    print("Test 4: Validación de Boot Mark...")
    
    gen = UnlockCodeGenerator(year="2023")
    
    # Casos válidos
    valid_marks = [
        "123456789",
        "ABCD1234",
        "12-34-56",
    ]
    
    # Casos inválidos
    invalid_marks = [
        "",
        "123",  # Muy corto
        "A" * 30,  # Muy largo
    ]
    
    all_passed = True
    
    for mark in valid_marks:
        if not gen.validate_boot_mark(mark):
            print(f"  ✗ FAIL: '{mark}' debería ser válido")
            all_passed = False
    
    for mark in invalid_marks:
        if gen.validate_boot_mark(mark):
            print(f"  ✗ FAIL: '{mark}' debería ser inválido")
            all_passed = False
    
    if all_passed:
        print("  ✓ OK: Validación de Boot Mark correcta")
    
    return all_passed


def test_code_generation_citd():
    """Test: Generación de código CITD (2021-2022)"""
    print("Test 5: Generación de código CITD...")
    
    gen = UnlockCodeGenerator(year="2021")
    
    success, message, code = gen.generate_unlock_code(
        hardware_id="TEST123ABC",
        boot_mark="456789XYZ"
    )
    
    if not success:
        print(f"  ✗ FAIL: {message}")
        return False
    
    if not code:
        print("  ✗ FAIL: Código no generado")
        return False
    
    # Verificar formato: XXXX-XXXX-XXXX-XXXX
    parts = code.split('-')
    if len(parts) != 4:
        print(f"  ✗ FAIL: Formato incorrecto (esperado 4 bloques, obtenido {len(parts)})")
        return False
    
    for part in parts:
        if len(part) != 4:
            print(f"  ✗ FAIL: Bloque de tamaño incorrecto: {part}")
            return False
    
    print(f"  ✓ OK: Código generado: {code}")
    return True


def test_code_generation_tds():
    """Test: Generación de código TDS (2023)"""
    print("Test 6: Generación de código TDS...")
    
    gen = UnlockCodeGenerator(year="2023")
    
    success, message, code = gen.generate_unlock_code(
        hardware_id="TEST123ABC",
        boot_mark="456789XYZ"
    )
    
    if not success:
        print(f"  ✗ FAIL: {message}")
        return False
    
    if not code:
        print("  ✗ FAIL: Código no generado")
        return False
    
    # Verificar formato: XXXXX-XXXXX-XXXXX
    parts = code.split('-')
    if len(parts) != 3:
        print(f"  ✗ FAIL: Formato incorrecto (esperado 3 bloques, obtenido {len(parts)})")
        return False
    
    for part in parts:
        if len(part) != 5:
            print(f"  ✗ FAIL: Bloque de tamaño incorrecto: {part}")
            return False
    
    print(f"  ✓ OK: Código generado: {code}")
    return True


def test_consistency():
    """Test: Consistencia de generación"""
    print("Test 7: Consistencia de códigos...")
    
    gen = UnlockCodeGenerator(year="2023")
    
    hw_id = "CONSISTENT123"
    boot_mark = "987654321"
    
    # Generar múltiples veces con los mismos datos
    codes = []
    for _ in range(3):
        success, _, code = gen.generate_unlock_code(hw_id, boot_mark)
        if not success:
            print("  ✗ FAIL: Error al generar código")
            return False
        codes.append(code)
    
    # Todos los códigos deben ser iguales
    if len(set(codes)) != 1:
        print(f"  ✗ FAIL: Códigos inconsistentes: {codes}")
        return False
    
    print(f"  ✓ OK: Códigos consistentes: {codes[0]}")
    return True


def test_get_info():
    """Test: Obtener información del generador"""
    print("Test 8: Información del generador...")
    
    gen = UnlockCodeGenerator(year="2023")
    info = gen.get_info()
    
    required_keys = ["year", "server_name", "server_url", "version"]
    
    for key in required_keys:
        if key not in info:
            print(f"  ✗ FAIL: Falta clave '{key}' en info")
            return False
    
    if info["year"] != "2023":
        print(f"  ✗ FAIL: Año incorrecto en info")
        return False
    
    print(f"  ✓ OK: Información correcta")
    return True


def run_all_tests():
    """Ejecuta todos los tests"""
    print("\n" + "="*60)
    print("DESBLOCK-NET - Suite de Tests")
    print("="*60 + "\n")
    
    tests = [
        test_generator_instantiation,
        test_invalid_year,
        test_hardware_id_validation,
        test_boot_mark_validation,
        test_code_generation_citd,
        test_code_generation_tds,
        test_consistency,
        test_get_info,
    ]
    
    passed = 0
    failed = 0
    
    for test in tests:
        try:
            if test():
                passed += 1
            else:
                failed += 1
        except Exception as e:
            print(f"  ✗ ERROR: {e}")
            failed += 1
        print()
    
    print("="*60)
    print(f"Resultados: {passed} pasados, {failed} fallados")
    print("="*60 + "\n")
    
    return failed == 0


if __name__ == "__main__":
    success = run_all_tests()
    sys.exit(0 if success else 1)

