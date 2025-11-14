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
