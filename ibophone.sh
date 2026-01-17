#!/bin/bash

# IBO Phone ISO Launcher
# Быстрый запуск ISO образа IBO Phone

set -e

# Цвета
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║           IBO Phone OS - Быстрый запуск               ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

check_and_create_iso() {
    echo -e "${YELLOW}Проверка ISO образа...${NC}"
    
    if [ -f "ibophone-1.0.0.iso" ] || [ -f "ibophone-1.0.0.iso.tar.gz" ]; then
        echo -e "${GREEN}✓ ISO образ найден${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}ISO образ не найден, создание...${NC}"
    bash create-iso.sh
    
    if [ -f "ibophone-1.0.0.iso.tar.gz" ]; then
        echo -e "${GREEN}✓ Архив образа создан${NC}"
    fi
}

run_with_qemu() {
    echo -e "${YELLOW}Запуск IBO Phone в QEMU...${NC}"
    echo ""
    echo "📱 IBO Phone OS запускается..."
    echo ""
    echo "Параметры виртуальной машины:"
    echo "  - Память: 2048 MB (2 GB)"
    echo "  - Процессоры: 4 ядра"
    echo "  - Архитектура: ARM64"
    echo "  - Диск: виртуальный (5 GB)"
    echo ""
    echo "Для выхода: нажмите Ctrl+C или закройте окно"
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo ""
    
    sleep 2
    
    # Создание виртуального диска если его нет
    if [ ! -f "ibophone-disk.img" ]; then
        echo "Создание виртуального диска (5GB)..."
        dd if=/dev/zero of=ibophone-disk.img bs=1M count=5120 2>/dev/null
        echo "✓ Диск создан"
    fi
    
    # Запуск QEMU
    if command -v qemu-system-aarch64 &> /dev/null; then
        qemu-system-aarch64 \
            -m 2048 \
            -smp 4 \
            -drive file=ibophone-disk.img,format=raw,if=virtio \
            -cdrom ibophone-1.0.0.iso.tar.gz \
            -boot c \
            -name "IBO Phone OS" \
            -nographic 2>/dev/null || true
    elif command -v qemu-system-x86_64 &> /dev/null; then
        echo "Запуск на x86_64..."
        qemu-system-x86_64 \
            -m 2048 \
            -smp 4 \
            -drive file=ibophone-disk.img,format=raw \
            -name "IBO Phone OS" \
            -nographic 2>/dev/null || true
    else
        echo -e "${RED}✗ QEMU не установлен${NC}"
        echo "Установите:"
        echo "  sudo apt-get install qemu-system-arm qemu-system-x86"
        exit 1
    fi
}

run_with_simulation() {
    echo -e "${YELLOW}Запуск симуляции IBO Phone...${NC}"
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║              IBO PHONE OS v1.0.0                       ║"
    echo "║                                                        ║"
    echo "║  ARM64 Linux Kernel 5.15.0                            ║"
    echo "║  1 GB RAM | 32 GB Storage                             ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    
    echo "Загрузка ядра..."
    sleep 1
    echo "  ✓ Linux kernel 5.15.0 загружен"
    sleep 1
    echo "  ✓ SELinux инициализирован"
    sleep 1
    echo "  ✓ Файловая система смонтирована"
    sleep 1
    
    echo ""
    echo "Загрузка приложений..."
    sleep 1
    echo "  ✓ IBO App Store запущен"
    sleep 1
    echo "  ✓ IBO Browser запущен"
    sleep 1
    echo "  ✓ Package Manager запущен"
    sleep 1
    
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║  ✓ IBO Phone OS полностью загружена и готова к работе ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    
    show_boot_menu
}

show_boot_menu() {
    echo ""
    echo "════════════════════════════════════════════════════════"
    echo "Главное меню IBO Phone OS"
    echo "════════════════════════════════════════════════════════"
    echo ""
    echo "1) IBO App Store        - Установка приложений"
    echo "2) IBO Browser          - Веб-браузер"
    echo "3) Терминал             - Командная строка"
    echo "4) Параметры системы    - Настройки"
    echo "5) Выключение           - Завершить работу"
    echo ""
    
    read -p "Выберите (1-5): " choice
    
    case $choice in
        1)
            echo ""
            echo "Запуск IBO App Store..."
            sleep 1
            echo "✓ App Store запущен"
            echo ""
            echo "Доступные приложения:"
            echo ""
            echo "🎮 ИГРЫ:"
            echo "  • Roblox v2.543.617        - Play any game you can imagine!"
            echo "  • Minecraft v1.19.60       - Build and explore worlds"
            echo ""
            echo "📱 ВИДЕО И СОЦИАЛЬНЫЕ СЕТИ:"
            echo "  • YouTube v18.01.39        - Смотри видео"
            echo "  • TikTok v35.2.1           - Короткие видео"
            echo "  • Instagram v288.0.0       - Социальная сеть"
            echo ""
            echo "💬 МЕССЕНДЖЕРЫ:"
            echo "  • Telegram v8.4.1          - Быстрая связь"
            echo "  • Discord v157.10          - Общение и голос"
            echo ""
            echo "🌐 БРАУЗЕРЫ:"
            echo "  • Chrome v96.0             - Google браузер"
            echo ""
            read -p "Установить приложение? (название/n): " app
            if [ "$app" != "n" ]; then
                echo "Установка $app..."
                sleep 2
                echo "✓ $app успешно установлен"
            fi
            show_boot_menu
            ;;
        2)
            echo ""
            echo "Запуск IBO Browser..."
            sleep 1
            echo "✓ Browser запущен"
            echo ""
            echo "Введите URL (например, https://example.com или 'exit' для выхода):"
            read -p "URL: " url
            if [ "$url" != "exit" ]; then
                echo "Загрузка $url..."
                sleep 2
                echo "✓ Страница загружена"
            fi
            show_boot_menu
            ;;
        3)
            echo ""
            echo "Терминал IBO Phone OS"
            echo "Введите команду (help для справки, exit для выхода):"
            while true; do
                read -p "$ " cmd
                case $cmd in
                    exit) break ;;
                    help) echo "Доступные команды: ls, ps, df, uname, top" ;;
                    ls) echo "apps system packages kernel boot" ;;
                    ps) echo "PID    NAME" && echo "1      init" && echo "2      appstore" && echo "3      browser" ;;
                    df) echo "Filesystem    Used  Available" && echo "/dev/root    2.5G    29.5G" ;;
                    uname) echo "Linux ibophone 5.15.0 #1 SMP Fri Jan 17 ARMv8 GNU/Linux" ;;
                    top) echo "PID  USER  CPU  MEM  COMMAND" && echo "2    root  0.5% 15%  appstore" && echo "3    root  0.3% 12%  browser" ;;
                    *) echo "Команда не найдена: $cmd" ;;
                esac
            done
            show_boot_menu
            ;;
        4)
            echo ""
            echo "Параметры системы"
            echo "  ОС: IBO Phone OS v1.0.0"
            echo "  Kernel: Linux 5.15.0"
            echo "  Архитектура: ARM64"
            echo "  RAM: 2048 MB"
            echo "  Дисковое пространство: 32 GB"
            echo "  Время загрузки: 2 сек"
            echo ""
            read -p "Нажмите Enter для продолжения..."
            show_boot_menu
            ;;
        5)
            echo ""
            echo "Завершение работы IBO Phone OS..."
            sleep 1
            echo "✓ Система завершена"
            exit 0
            ;;
        *)
            echo "Неверный выбор"
            show_boot_menu
            ;;
    esac
}

show_menu() {
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "Выберите способ запуска IBO Phone:"
    echo "═══════════════════════════════════════════════════════"
    echo ""
    echo "1) Симуляция (интерактивная)"
    echo "2) QEMU эмулятор"
    echo "3) Информация об ISO"
    echo "4) Выход"
    echo ""
}

main() {
    print_header
    
    check_and_create_iso
    
    while true; do
        show_menu
        read -p "Выберите (1-4): " choice
        
        case $choice in
            1)
                run_with_simulation
                ;;
            2)
                run_with_qemu
                ;;
            3)
                if [ -f "ibophone-1.0.0.iso.info" ]; then
                    cat "ibophone-1.0.0.iso.info"
                else
                    echo "Информация об ISO не найдена"
                fi
                ;;
            4)
                echo -e "${GREEN}До свидания!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}✗ Неверный выбор${NC}"
                ;;
        esac
        
        echo ""
        read -p "Нажмите Enter для продолжения..."
    done
}

main "$@"
