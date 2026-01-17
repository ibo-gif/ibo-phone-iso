#!/bin/bash

# IBO Phone ISO Build Script
# Скрипт сборки ISO образа IBO Phone

set -e

VERSION="1.0.0"
BUILD_DIR="$(pwd)/build_output"
ISO_NAME="ibo-phone-${VERSION}.iso"

echo "==============================================="
echo "IBO Phone ISO Builder v${VERSION}"
echo "==============================================="

# Создание директории сборки
echo "[1/6] Создание директории сборки..."
mkdir -p "${BUILD_DIR}"/{kernel,system,apps,boot}

# Копирование kernel
echo "[2/6] Копирование kernel..."
cp -r kernel/* "${BUILD_DIR}/kernel/" 2>/dev/null || echo "Kernel файлы не найдены"

# Копирование системных файлов
echo "[3/6] Копирование системных файлов..."
cp -r system/* "${BUILD_DIR}/system/" 2>/dev/null || echo "System файлы не найдены"

# Компиляция приложений
echo "[4/6] Компиляция приложений..."
echo "  - Компиляция App Store..."
javac -d "${BUILD_DIR}/apps" apps/ibo-appstore/*.java 2>/dev/null || echo "Ошибка при компиляции App Store"

echo "  - Компиляция Browser..."
javac -d "${BUILD_DIR}/apps" apps/ibo-browser/*.java 2>/dev/null || echo "Ошибка при компиляции Browser"

# Копирование пакетов
echo "[5/6] Копирование APK/AAB пакетов..."
mkdir -p "${BUILD_DIR}/packages"/{apk,aab}
cp packages/apk/* "${BUILD_DIR}/packages/apk/" 2>/dev/null || echo "APK пакеты не найдены"
cp packages/aab/* "${BUILD_DIR}/packages/aab/" 2>/dev/null || echo "AAB пакеты не найдены"

# Создание ISO образа
echo "[6/6] Создание ISO образа..."
if command -v mkisofs &> /dev/null; then
    mkisofs -o "${BUILD_DIR}/${ISO_NAME}" "${BUILD_DIR}"
    echo ""
    echo "==============================================="
    echo "✓ ISO образ успешно создан!"
    echo "  Файл: ${BUILD_DIR}/${ISO_NAME}"
    echo "==============================================="
elif command -v genisoimage &> /dev/null; then
    genisoimage -o "${BUILD_DIR}/${ISO_NAME}" "${BUILD_DIR}"
    echo ""
    echo "==============================================="
    echo "✓ ISO образ успешно создан!"
    echo "  Файл: ${BUILD_DIR}/${ISO_NAME}"
    echo "==============================================="
else
    echo "⚠ ISO инструменты не установлены"
    echo "  Установите: mkisofs или genisoimage"
fi
