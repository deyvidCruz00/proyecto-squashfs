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

## Documentación Adicional

Para información detallada, consulte:
- [`ARQUITECTURA.md`](ARQUITECTURA.md) - Diseño técnico y componentes del sistema
- [`ANALISIS_EXPERIMENTAL.md`](ANALISIS_EXPERIMENTAL.md) - Resultados y métricas experimentales





### Referencias Académicas
- Love, R. (2010). *Linux Kernel Development (3rd ed.)*. Addison-Wesley.
- SquashFS Project: https://github.com/plougher/squashfs-tools
- Kerrisk, M. (2010). *The Linux Programming Interface*. No Starch Press.


---

**Última actualización**: Noviembre 2025
**Versión del proyecto**: 1.0  
**Compatibilidad**: Linux kernel >= 2.6.29 con soporte SquashFS
