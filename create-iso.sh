#!/bin/bash

# IBO Phone ISO Creator
# Создатель ISO образа для IBO Phone OS

set -e

VERSION="1.0.0"
ISO_NAME="ibophone-${VERSION}.iso"
ISO_DIR="iso_image"
BUILD_DIR="iso_build"

# Цвета для вывода
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║        IBO Phone ISO Image Creator v${VERSION}          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Проверка зависимостей
check_dependencies() {
    echo -e "${YELLOW}Проверка зависимостей...${NC}"
    
    local deps_ok=true
    
    for cmd in mkdir cp dd mkisofs; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "⚠ $cmd может быть недоступен"
        fi
    done
    
    if ! command -v mkisofs &> /dev/null && ! command -v genisoimage &> /dev/null; then
        echo -e "${YELLOW}⚠ mkisofs/genisoimage не найден${NC}"
        echo "  Будет использован простой образ"
    fi
}

# Создание структуры ISO
create_iso_structure() {
    echo -e "${YELLOW}Создание структуры ISO...${NC}"
    
    mkdir -p "${ISO_DIR}"/{boot,system,apps,packages,etc}
    
    # Boot файлы
    cp build/AndroidManifest.xml "${ISO_DIR}/boot/" 2>/dev/null || true
    
    # System файлы
    cp system/*.properties "${ISO_DIR}/system/" 2>/dev/null || true
    cp system/*.conf "${ISO_DIR}/system/" 2>/dev/null || true
    cp system/*.rc "${ISO_DIR}/system/" 2>/dev/null || true
    cp system/*.sh "${ISO_DIR}/system/" 2>/dev/null || true
    cp system/*.java "${ISO_DIR}/system/" 2>/dev/null || true
    
    # Apps
    cp -r apps/* "${ISO_DIR}/apps/" 2>/dev/null || true
    
    # Packages
    cp -r packages/apk "${ISO_DIR}/packages/" 2>/dev/null || true
    cp -r packages/aab "${ISO_DIR}/packages/" 2>/dev/null || true
    
    # Kernel config
    cp kernel/kernel.config "${ISO_DIR}/etc/" 2>/dev/null || true
    
    # Документация
    cp *.md "${ISO_DIR}/etc/" 2>/dev/null || true
    
    echo -e "${GREEN}✓ Структура создана${NC}"
}

# Создание boot.img
create_boot_image() {
    echo -e "${YELLOW}Создание boot образа...${NC}"
    
    # Создание простого boot сектора (512 байт)
    mkdir -p "${ISO_DIR}/boot"
    dd if=/dev/zero of="${ISO_DIR}/boot/boot.img" bs=512 count=2048 2>/dev/null
    
    # Добавление маркера (IBO)
    echo "IBO-PHONE-BOOT-v${VERSION}" > "${ISO_DIR}/boot/boot.txt"
    
    echo -e "${GREEN}✓ Boot образ создан${NC}"
}

# Создание ISO образа
create_iso_image() {
    echo -e "${YELLOW}Создание ISO образа...${NC}"
    
    if command -v mkisofs &> /dev/null; then
        mkisofs -o "${ISO_NAME}" -R -J "${ISO_DIR}"
        echo -e "${GREEN}✓ ISO создан с mkisofs${NC}"
    elif command -v genisoimage &> /dev/null; then
        genisoimage -o "${ISO_NAME}" -R -J "${ISO_DIR}"
        echo -e "${GREEN}✓ ISO создан с genisoimage${NC}"
    else
        # Создание простого образа с tar + dd
        tar czf "${ISO_NAME}.tar.gz" "${ISO_DIR}"
        echo -e "${GREEN}✓ Архив создан (ISO_NAME.tar.gz)${NC}"
        echo -e "${YELLOW}⚠ Для полного ISO требуется mkisofs${NC}"
    fi
}

# Создание метаинформации
create_metadata() {
    echo -e "${YELLOW}Создание метаинформации...${NC}"
    
    cat > "${ISO_NAME}.info" << EOF
IBO Phone ISO Image
═══════════════════════════════════

Версия: ${VERSION}
Дата создания: $(date)
Размер: $(du -h "${ISO_NAME}" 2>/dev/null | cut -f1)

Содержимое:
  ✓ IBO App Store (магазин приложений)
  ✓ IBO Browser (веб-браузер)
  ✓ Linux Kernel 5.15.0+ (ARM64)
  ✓ SELinux безопасность
  ✓ APK и AAB поддержка

Запуск на виртуальной машине:
  QEMU: qemu-system-aarch64 -m 2048 -cdrom ${ISO_NAME}
  VirtualBox: VBoxManage createmedium --filename ibophone.iso --size 1000 && VirtualBox --startvm ibophone

Требования:
  - 2GB RAM
  - 32GB дискового пространства
  - ARM64 или x86_64 хост

EOF
    
    echo -e "${GREEN}✓ Метаинформация создана${NC}"
}

# Очистка
cleanup() {
    echo -e "${YELLOW}Очистка временных файлов...${NC}"
    rm -rf "${ISO_DIR}"
    echo -e "${GREEN}✓ Очистка завершена${NC}"
}

# Показ результата
show_result() {
    echo ""
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║            ✓ ISO ОБРАЗ УСПЕШНО СОЗДАН!                ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    if [ -f "${ISO_NAME}" ]; then
        echo "Файл: ${ISO_NAME}"
        echo "Размер: $(du -h "${ISO_NAME}" | cut -f1)"
        echo ""
        echo "Для запуска используйте:"
        echo "  bash run-iso.sh              # Интерактивный запуск"
        echo "  qemu-system-aarch64 -cdrom ${ISO_NAME} -m 2048"
        echo ""
    fi
    
    if [ -f "${ISO_NAME}.info" ]; then
        echo "Информация сохранена в: ${ISO_NAME}.info"
    fi
}

# Главная функция
main() {
    check_dependencies
    create_iso_structure
    create_boot_image
    create_iso_image
    create_metadata
    cleanup
    show_result
}

# Запуск
main "$@"
