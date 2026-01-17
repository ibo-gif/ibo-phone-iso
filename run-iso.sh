#!/bin/bash

# IBO Phone ISO Runner
# Запуск ISO образа IBO Phone на виртуальной машине

set -e

ISO_FILE="ibophone-1.0.0.iso"
QEMU_ARM="qemu-system-aarch64"
QEMU_X86="qemu-system-x86_64"
VBOX_VM="ibophone-vm"

# Цвета
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║         IBO Phone ISO Runner                           ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_iso() {
    if [ ! -f "${ISO_FILE}" ]; then
        echo -e "${RED}✗ Файл ISO не найден: ${ISO_FILE}${NC}"
        echo ""
        echo "Для создания ISO образа используйте:"
        echo "  bash create-iso.sh"
        exit 1
    fi
    echo -e "${GREEN}✓ ISO файл найден: ${ISO_FILE}${NC}"
}

check_emulator() {
    echo -e "${YELLOW}Проверка доступных эмуляторов...${NC}"
    
    if command -v "$QEMU_ARM" &> /dev/null; then
        echo -e "${GREEN}✓ QEMU ARM64 найден${NC}"
        return 0
    elif command -v "$QEMU_X86" &> /dev/null; then
        echo -e "${GREEN}✓ QEMU x86_64 найден${NC}"
        QEMU_ARM="$QEMU_X86"
        return 0
    elif command -v VirtualBox &> /dev/null; then
        echo -e "${GREEN}✓ VirtualBox найден${NC}"
        return 0
    else
        echo -e "${RED}✗ Ни один эмулятор не найден${NC}"
        echo ""
        echo "Установите один из:"
        echo "  Ubuntu/Debian: sudo apt-get install qemu-system"
        echo "  или: sudo apt-get install virtualbox"
        exit 1
    fi
}

show_menu() {
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "Выберите способ запуска:"
    echo "═══════════════════════════════════════════════════════"
    echo "1) QEMU (быстро, легко)"
    echo "2) VirtualBox (графический интерфейс)"
    echo "3) Просмотр информации об ISO"
    echo "4) Выход"
    echo ""
}

run_qemu() {
    echo -e "${YELLOW}Запуск QEMU с IBO Phone ISO...${NC}"
    echo ""
    echo "Параметры:"
    echo "  - Память: 2048 MB"
    echo "  - Процессоры: 4"
    echo "  - Архитектура: ARM64"
    echo ""
    echo "Для выхода: нажмите Ctrl+C или закройте окно QEMU"
    echo ""
    echo -e "${YELLOW}Запуск...${NC}"
    echo ""
    
    sleep 2
    
    if command -v "$QEMU_ARM" &> /dev/null; then
        "$QEMU_ARM" \
            -m 2048 \
            -smp 4 \
            -cdrom "${ISO_FILE}" \
            -boot d \
            -display gtk \
            -name "IBO Phone OS"
    else
        echo -e "${RED}✗ QEMU не доступен${NC}"
        exit 1
    fi
}

run_virtualbox() {
    echo -e "${YELLOW}Подготовка VirtualBox...${NC}"
    
    if ! command -v VirtualBox &> /dev/null; then
        echo -e "${RED}✗ VirtualBox не установлен${NC}"
        echo "Установите: sudo apt-get install virtualbox"
        exit 1
    fi
    
    # Проверка наличия ВМ
    if VBoxManage list vms | grep -q "$VBOX_VM"; then
        echo -e "${GREEN}✓ ВМ уже существует${NC}"
        read -p "Запустить существующую ВМ? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            VBoxManage startvm "$VBOX_VM" --type gui
        fi
    else
        echo -e "${YELLOW}Создание новой ВМ...${NC}"
        
        # Создание ВМ
        VBoxManage createvm --name "$VBOX_VM" --ostype "Linux_64" --register
        
        # Настройка памяти и CPU
        VBoxManage modifyvm "$VBOX_VM" --memory 2048 --cpus 4
        
        # Добавление CD привода
        VBoxManage storagectl "$VBOX_VM" --name "IDE" --add ide
        VBoxManage storageattach "$VBOX_VM" --storagectl "IDE" \
            --port 0 --device 0 --type dvddrive --medium "${ISO_FILE}"
        
        echo -e "${GREEN}✓ ВМ создана${NC}"
        echo ""
        echo "Для запуска:"
        echo "  VirtualBox &"
        echo "  или"
        echo "  VBoxManage startvm $VBOX_VM --type gui"
    fi
}

show_info() {
    echo ""
    if [ -f "${ISO_FILE}.info" ]; then
        cat "${ISO_FILE}.info"
    else
        echo "Информация об ISO:"
        echo "  Файл: ${ISO_FILE}"
        echo "  Размер: $(du -h "${ISO_FILE}" | cut -f1)"
        echo "  Дата: $(date -r "${ISO_FILE}")"
    fi
    echo ""
}

main() {
    print_header
    
    check_iso
    check_emulator
    
    while true; do
        show_menu
        read -p "Выберите (1-4): " choice
        
        case $choice in
            1)
                run_qemu
                ;;
            2)
                run_virtualbox
                ;;
            3)
                show_info
                ;;
            4)
                echo -e "${GREEN}До свидания!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}✗ Неверный выбор${NC}"
                ;;
        esac
    done
}

main "$@"
