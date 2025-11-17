# Arquitectura del Sistema - SquashFS Read-Only

## Visión General

Este documento describe la arquitectura técnica de la implementación de sistemas de archivos de solo lectura utilizando SquashFS, detallando los componentes, flujos de datos y decisiones de diseño.

## Arquitectura de Componentes

### 1. Capa de Datos (src/data/)
```
src/data/
├── leerme.txt          # Archivo de ejemplo en texto plano
└── docs/
    └── info.md         # Documentación en formato Markdown
```

**Propósito**: Contiene los datos fuente que serán empaquetados en la imagen SquashFS inmutable.

**Características**:
- Estructura jerárquica simple
- Archivos de diferentes tipos (texto, markdown)
- Tamaño optimizado para demostración

### 2. Capa de Automatización (scripts/)

#### setup.sh
```bash
#!/bin/bash
set -e
sudo apt update
sudo apt install -y squashfs-tools dos2unix
echo "[OK] Dependencias instaladas"
```

**Funcionalidad**:
- Actualización del sistema de paquetes
- Instalación de `squashfs-tools`
- Instalación de `dos2unix`
- Manejo de errores con `set -e`

#### build_squashfs.sh
```bash
#!/bin/bash
set -e

ROOT_DIR="src/data"
OUTPUT="filesystem.sqsh"

if [ ! -d "$ROOT_DIR" ]; then
    echo "[ERROR] La carpeta $ROOT_DIR no existe."
    exit 1
fi

echo "[INFO] Generando imagen SquashFS..."
mksquashfs "$ROOT_DIR" "$OUTPUT" -noappend -comp gzip

echo "[OK] Imagen creada: $OUTPUT"
```

**Análisis Técnico**:
- **Validación de precondiciones**: Verifica existencia del directorio fuente
- **Parámetros de `mksquashfs`**:
  - `-noappend`: Sobrescribe imagen existente
  - `-comp gzip`: Compresión GZIP para balance tamaño/velocidad
- **Gestión de errores**: Terminación inmediata en caso de fallo

#### test_readonly.sh
```bash
#!/bin/bash
set -e

OUTPUT="filesystem.sqsh"
MOUNT_DIR="mnt_ro"

if [ ! -f "$OUTPUT" ]; then
    echo "[ERROR] No existe $OUTPUT. Ejecuta build_squashfs.sh."
    exit 1
fi

mkdir -p "$MOUNT_DIR"
sudo mount -t squashfs "$OUTPUT" "$MOUNT_DIR" -o loop

echo "[INFO] Contenido del FS:"
ls -la "$MOUNT_DIR"

echo "[INFO] Probando escritura (debe fallar):"
if sudo sh -c "echo hola > $MOUNT_DIR/test.txt" 2>/dev/null; then
    echo "[ERROR] ¡Se pudo escribir!"
else
    echo "[OK] No se permite escribir (read-only)"
fi

sudo umount "$MOUNT_DIR"
rmdir "$MOUNT_DIR"
```

**Análisis de Validación**:
- **Montaje con loop device**: Simula un dispositivo de bloque
- **Verificación de contenido**: Lista archivos y directorios
- **Prueba de inmutabilidad**: Intenta escritura que debe fallar
- **Limpieza automática**: Desmontaje y eliminación del punto de montaje

### 3. Capa de Evidencia (evidencia/)

#### build_log.txt - Análisis de Métricas
```
Filesystem size 0.32 Kbytes (0.00 Mbytes)
77.73% of uncompressed filesystem size (0.41 Kbytes)
```

**Indicadores de Eficiencia**:
- **Ratio de compresión**: 77.73% del tamaño original
- **Tamaño final**: 0.32 KB (excelente compresión para datos pequeños)
- **Duplicados**: 0 archivos duplicados encontrados

#### test_log.txt - Validación de Seguridad
```
[INFO] Probando escritura (debe fallar):
[OK] No se permite escribir (read-only)
```

**Verificación de Inmutabilidad**:
- Intento de escritura correctamente bloqueado
- Sistema de archivos mantiene propiedades de solo lectura
- Validación exitosa de restricciones de seguridad

## Flujo de Datos

```
[Datos Fuente] → [Compresión SquashFS] → [Imagen Binaria] → [Montaje Loop] → [Sistema RO]
     ↓                    ↓                    ↓               ↓              ↓
  src/data/         mksquashfs         filesystem.sqsh    mount -o loop   Validación
```

## Decisiones de Diseño

### 1. Elección de SquashFS
**Justificación**:
- **Compresión eficiente**: Reduce significativamente el tamaño
- **Inmutabilidad garantizada**: No permite modificaciones post-creación
- **Soporte nativo en Linux**: Integración directa con el kernel
- **Portable**: La imagen puede moverse entre sistemas

### 2. Compresión GZIP
**Razones técnicas**:
- Balance entre velocidad de compresión/descompresión y ratio
- Amplio soporte y compatibilidad
- Menor uso de CPU comparado con algoritmos más agresivos

### 3. Automatización con Scripts Bash
**Ventajas**:
- **Reproducibilidad**: Mismos resultados en cada ejecución
- **Documentación executable**: Los scripts sirven como documentación
- **Validación integrada**: Verificaciones automáticas de precondiciones
- **Manejo de errores**: Terminación segura ante fallos

## Consideraciones de Seguridad

### Inmutabilidad
- Los archivos no pueden ser modificados una vez creada la imagen
- El sistema de archivos no permite escritura ni eliminación
- Ideal para entornos que requieren integridad de datos

### Verificación de Integridad
- La estructura SquashFS incluye checksums internos
- Cualquier corrupción en la imagen es detectable
- El montaje falla si la imagen está corrupta

### Aislamiento
- Los datos están encapsulados en una imagen binaria
- No hay acceso directo a archivos individuales sin montaje
- Control granular sobre el acceso mediante permisos de montaje

## Limitaciones y Consideraciones

### Limitaciones Técnicas
- **Tamaño máximo**: Limitado por el formato SquashFS (teóricamente 2^64 bytes)
- **Actualización**: Requiere recrear toda la imagen para cambios
- **Memoria**: El kernel cachea metadatos de la imagen

### Consideraciones de Rendimiento
- **Descompresión on-demand**: Los datos se descomprimen al acceder
- **Cache del kernel**: Mejora significativamente el rendimiento en accesos repetidos
- **CPU vs Storage**: Trade-off entre uso de CPU para descompresión y espacio en disco

## Casos de Uso Recomendados

1. **Sistemas Embebidos**: Firmware y sistemas operativos inmutables
2. **Contenedores**: Capas base de imágenes Docker
3. **Live CDs/USBs**: Distribuciones Linux portables
4. **Backup de Configuraciones**: Snapshots inmutables de configuraciones críticas
5. **Distribución de Software**: Paquetes de aplicaciones auto-contenidos