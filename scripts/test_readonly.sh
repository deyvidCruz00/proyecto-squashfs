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
