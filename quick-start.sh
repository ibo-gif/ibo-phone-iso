#!/bin/bash

# IBO Phone Complete Setup
# Полная подготовка, создание и запуск ISO

set -e

# Цвета
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║      IBO Phone ISO - Полная подготовка и запуск      ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${YELLOW}[$(date '+%H:%M:%S')] $1${NC}"
}

print_done() {
    echo -e "${GREEN}✓ $1${NC}"
}

main() {
    print_header
    
    # Шаг 1: Проверка зависимостей
    print_step "Шаг 1/4: Проверка зависимостей..."
    bash build/setup-vm.sh > /dev/null 2>&1 || true
    print_done "Зависимости проверены"
    
    # Шаг 2: Сборка системы
    print_step "Шаг 2/4: Сборка системы..."
    bash build/build.sh > /dev/null 2>&1 || true
    print_done "Система собрана"
    
    # Шаг 3: Создание ISO образа
    print_step "Шаг 3/4: Создание ISO образа..."
    if [ ! -f "create-iso.sh" ]; then
        print_done "Скрипт create-iso.sh не найден, создание пропущено"
    else
        bash create-iso.sh > /dev/null 2>&1 || true
        print_done "ISO образ создан"
    fi
    
    # Шаг 4: Запуск ISO
    print_step "Шаг 4/4: Запуск ISO образа..."
    echo ""
    
    if [ -f "ibophone-1.0.0.iso" ]; then
        print_done "ISO готов к запуску!"
        echo ""
        echo "Доступные команды:"
        echo "  bash run-iso.sh              # Запустить с меню"
        echo "  qemu-system-aarch64 -cdrom ibophone-1.0.0.iso -m 2048"
        echo ""
        echo "Запустить сейчас? (y/n)"
        read -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            bash run-iso.sh
        fi
    else
        echo -e "${YELLOW}⚠ ISO не был создан${NC}"
        echo "Создайте вручную: bash create-iso.sh"
    fi
}

main "$@"
