# Sistemas de Archivos de Solo Lectura: Implementación con SquashFS

## Descripción del Proyecto

Este proyecto implementa una solución práctica de **sistemas de archivos de solo lectura** utilizando **SquashFS**, demostrando conceptos fundamentales de seguridad, persistencia y gestión de sistemas de archivos inmutables. La implementación forma parte de la sustentación del tema "Sistemas de Archivos de Solo Lectura: Seguridad y Persistencia".

## Objetivos

- **Objetivo Principal**: Demostrar la creación, montaje y validación de sistemas de archivos inmutables usando SquashFS
- **Objetivos Específicos**:
  - Implementar la construcción automatizada de imágenes SquashFS
  - Validar las propiedades de solo lectura del sistema de archivos
  - Documentar el proceso completo de implementación
  - Analizar las características de compresión y seguridad

## Arquitectura de la Solución

### Componentes del Sistema

```
proyecto-squashfs/
├── src/data/           # Datos fuente para la imagen SquashFS
├── scripts/            # Scripts de automatización
│   ├── setup.sh       # Instalación de dependencias
│   ├── build_squashfs.sh  # Construcción de la imagen
│   └── test_readonly.sh   # Validación de propiedades
├── docs/              # Documentación del proyecto
├── evidencia/         # Logs y evidencia experimental
└── README.md          # Documentación principal
```

### Flujo de Trabajo

1. **Preparación del Entorno** (`setup.sh`)
2. **Construcción de la Imagen** (`build_squashfs.sh`)
3. **Montaje y Validación** (`test_readonly.sh`)

## Requisitos del Sistema

### Dependencias
- **Sistema Operativo**: Linux (Ubuntu/Debian recomendado)
- **Herramientas Requeridas**:
  - `squashfs-tools`: Herramientas para crear y manipular imágenes SquashFS
  - `dos2unix`: Conversión de formato de archivos
  - `sudo`: Privilegios administrativos para montaje

### Especificaciones Técnicas
- **Formato**: SquashFS 4.0
- **Compresión**: GZIP
- **Tamaño de bloque**: 131072 bytes
- **Modo de montaje**: Solo lectura con loop device

## Guía de Ejecución

### Instalación y Configuración

```bash
# 1. Clonar el repositorio
git clone <repository-url>
cd proyecto-squashfs

# 2. Instalar dependencias
bash scripts/setup.sh

# 3. Construir la imagen SquashFS
bash scripts/build_squashfs.sh

# 4. Probar el sistema de archivos
bash scripts/test_readonly.sh
```

### Uso Paso a Paso

#### 1. Preparación del Entorno
```bash
bash scripts/setup.sh
```
Este script instala automáticamente todas las dependencias necesarias.

#### 2. Construcción de la Imagen
```bash
bash scripts/build_squashfs.sh
```
Genera `filesystem.sqsh` a partir del contenido de `src/data/`.

#### 3. Validación de Propiedades
```bash
bash scripts/test_readonly.sh
```
## Características Técnicas

### Especificaciones de SquashFS
- **Versión**: SquashFS 4.0
- **Compresión**: GZIP (configurable)
- **Tamaño de bloque**: 131072 bytes
- **Soporte de archivos**: Hasta 2^64 bytes
- **Metadatos**: Comprimidos con checksums

### Métricas de Rendimiento Observadas
- **Ratio de compresión**: 77.73% del tamaño original
- **Tiempo de construcción**: ~45ms para datasets pequeños
- **Uso de memoria**: < 1MB durante construcción
- **Deduplicación**: Automática de archivos idénticos

## Análisis de Resultados

### Compresión y Eficiencia
```
Filesystem size: 0.32 KB (compressed)
Original size: 0.41 KB (uncompressed)
Compression ratio: 22.27% space savings
Metadata overhead: 61 bytes (inode table) + 55 bytes (directory table)
```

### Validación de Seguridad
✅ **Inmutabilidad verificada**: Todas las operaciones de escritura fallan correctamente
✅ **Integridad garantizada**: Checksums automáticos detectan corrupción
✅ **Permisos preservados**: Estructura original mantenida tras montaje
✅ **Aislamiento efectivo**: No hay acceso directo a archivos sin montaje

## Documentación Adicional

Para información detallada, consulte:
- [`ARQUITECTURA.md`](ARQUITECTURA.md) - Diseño técnico y componentes del sistema
- [`MARCO_TEORICO.md`](MARCO_TEORICO.md) - Fundamentos teóricos y conceptos aplicados
- [`ANALISIS_EXPERIMENTAL.md`](ANALISIS_EXPERIMENTAL.md) - Resultados y métricas experimentales
- [`DOCUMENTO_INTEGRADOR.md`](DOCUMENTO_INTEGRADOR.md) - Síntesis teoría-práctica completa

## Casos de Uso

### Sistemas Embebidos
- **Firmware inmutable**: Protección contra corrupción de software base
- **Configuraciones críticas**: Snapshots de configuraciones conocidas buenas
- **Distribución de actualizaciones**: Paquetes autocontenidos

### Containerización
- **Container base images**: Layers inmutables para contenedores Docker
- **Application packaging**: Distribución de aplicaciones autocontenidas
- **Configuration as Code**: Gestión declarativa de configuraciones

### Seguridad y Compliance
- **Forensic imaging**: Preservación de evidencia digital
- **Backup immutable**: Snapshots protegidos contra ransomware
- **Audit trails**: Registros inmutables para compliance

## Limitaciones y Consideraciones

### Limitaciones Técnicas
- **Inmutabilidad absoluta**: No permite actualizaciones incrementales
- **Overhead de metadatos**: Significativo para archivos muy pequeños
- **Reconstrucción completa**: Cambios requieren recrear toda la imagen

### Consideraciones de Rendimiento
- **CPU vs Storage**: Trade-off entre compresión y velocidad de acceso
- **Memory usage**: Page cache mejora rendimiento en accesos repetidos
- **I/O patterns**: Optimizado para acceso secuencial, no aleatorio

## Troubleshooting

### Problemas Comunes

#### Error: "squashfs-tools not found"
```bash
# Solución: Instalar dependencias
sudo apt update
sudo apt install -y squashfs-tools
```

#### Error: "Permission denied" durante montaje
```bash
# Solución: Usar sudo para operaciones de montaje
sudo mount -t squashfs filesystem.sqsh mount_point -o loop
```

#### Error: "Directory not empty" al desmontar
```bash
# Solución: Cerrar todos los procesos usando el directorio
lsof +D /path/to/mount_point
sudo umount /path/to/mount_point
```

### Validación de Integridad
```bash
# Verificar integridad de la imagen
file filesystem.sqsh
# Debe mostrar: "Squashfs filesystem, little endian, version 4.0"

# Verificar que el montaje funciona
sudo mount -t squashfs filesystem.sqsh test_mount -o loop,ro
ls -la test_mount/
sudo umount test_mount
```

## Contribución y Extensiones

### Mejoras Propuestas
1. **Automatización CI/CD**: Integración con pipelines de construcción
2. **Monitoring**: Scripts de verificación de integridad programados
3. **Multi-algoritmo**: Soporte para múltiples algoritmos de compresión
4. **Containerización**: Dockerfiles para entornos reproducibles

### Estructura para Contribuciones
```bash
# Fork del repositorio
git clone <your-fork>
cd proyecto-squashfs

# Crear branch para feature
git checkout -b feature/nueva-funcionalidad

# Implementar cambios con tests
./scripts/test_readonly.sh

# Documentar cambios
# Crear commit con mensaje descriptivo
git commit -m "feat: agregar soporte para compresión XZ"

# Crear pull request
```

## License y Referencias

### Licencia
Este proyecto se distribuye bajo [especificar licencia], permitiendo uso académico y modificación con atribución apropiada.

### Referencias Académicas
- Love, R. (2010). *Linux Kernel Development (3rd ed.)*. Addison-Wesley.
- SquashFS Project: https://github.com/plougher/squashfs-tools
- Kerrisk, M. (2010). *The Linux Programming Interface*. No Starch Press.

### Contacto
Para consultas académicas o técnicas sobre esta implementación:
- **Repositorio**: [URL del repositorio]
- **Documentación**: Ver directorio `docs/` para análisis detallado
- **Issues**: Reportar problemas en el issue tracker del repositorio

---

**Última actualización**: Noviembre 2024  
**Versión del proyecto**: 1.0  
**Compatibilidad**: Linux kernel >= 2.6.29 con soporte SquashFS
