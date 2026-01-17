#!/usr/bin/env bash

# IBO Phone ISO - Интерактивный инсталлятор
# Этот скрипт помогает начать работу с IBO Phone ISO системой

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
print_header() {
    echo -e "${BLUE}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "   IBO Phone ISO - Интерактивный инсталлятор"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Проверка зависимостей
check_dependencies() {
    echo ""
    print_info "Проверка зависимостей..."
    
    local missing_deps=0
    
    for cmd in java javac bash df; do
        if command -v "$cmd" &> /dev/null; then
            print_success "$cmd установлен"
        else
            print_error "$cmd не установлен"
            missing_deps=$((missing_deps + 1))
        fi
    done
    
    if [ $missing_deps -gt 0 ]; then
        echo ""
        print_error "Отсутствуют $missing_deps зависимостей"
        echo "Установите их с помощью:"
        echo "  Ubuntu/Debian: sudo apt-get install default-jdk"
        return 1
    fi
    
    print_success "Все зависимости установлены!"
    return 0
}

# Система информация
show_system_info() {
    echo ""
    print_info "Информация о системе:"
    echo "  OS: $(uname -s)"
    echo "  Архитектура: $(uname -m)"
    echo "  Ядро: $(uname -r)"
    echo "  Java версия: $(java -version 2>&1 | head -1)"
    echo "  Свободная память: $(df "$SCRIPT_DIR" | tail -1 | awk '{print $4}')K"
}

# Подготовка системы
prepare_system() {
    echo ""
    print_info "Подготовка системы..."
    
    if [ -f "$SCRIPT_DIR/build/setup-vm.sh" ]; then
        bash "$SCRIPT_DIR/build/setup-vm.sh"
        print_success "Система подготовлена"
    else
        print_error "Скрипт setup-vm.sh не найден"
        return 1
    fi
}

# Меню действий
show_menu() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Выберите действие:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "1) Просмотреть документацию"
    echo "2) Подготовить систему"
    echo "3) Построить ISO образ"
    echo "4) Установить приложение"
    echo "5) Список установленных приложений"
    echo "6) Удалить приложение"
    echo "7) Запустить Docker контейнер"
    echo "8) Показать информацию о проекте"
    echo "9) Выход"
    echo ""
}

# Просмотр документации
view_documentation() {
    echo ""
    echo "Доступные документы:"
    echo "1) README.md - Основное описание"
    echo "2) USAGE_GUIDE.md - Руководство пользователя"
    echo "3) SPECIFICATION.md - Техническая спецификация"
    echo "4) EXAMPLES.md - Примеры кода"
    echo "5) QUICK_SUMMARY.md - Краткая сводка"
    echo ""
    read -p "Выберите документ (1-5): " doc_choice
    
    case $doc_choice in
        1) less "$SCRIPT_DIR/README.md" ;;
        2) less "$SCRIPT_DIR/USAGE_GUIDE.md" ;;
        3) less "$SCRIPT_DIR/SPECIFICATION.md" ;;
        4) less "$SCRIPT_DIR/EXAMPLES.md" ;;
        5) less "$SCRIPT_DIR/QUICK_SUMMARY.md" ;;
        *) print_error "Неверный выбор" ;;
    esac
}

# Сборка ISO
build_iso() {
    echo ""
    if [ -f "$SCRIPT_DIR/build/build.sh" ]; then
        print_info "Начало сборки ISO образа..."
        bash "$SCRIPT_DIR/build/build.sh"
        print_success "ISO образ создан в build_output/"
    else
        print_error "Скрипт build.sh не найден"
    fi
}

# Установка приложения
install_app() {
    echo ""
    read -p "Введите путь к файлу приложения (APK или AAB): " app_file
    
    if [ ! -f "$app_file" ]; then
        print_error "Файл не найден: $app_file"
        return 1
    fi
    
    read -p "Введите имя пакета (например, com.example.app): " package_name
    
    if [[ "$app_file" == *.apk ]]; then
        bash "$SCRIPT_DIR/system/install_packages.sh" install-apk "$app_file" "$package_name"
    elif [[ "$app_file" == *.aab ]]; then
        bash "$SCRIPT_DIR/system/install_packages.sh" install-aab "$app_file" "$package_name"
    else
        print_error "Неподдерживаемый формат файла"
    fi
}

# Список приложений
list_apps() {
    echo ""
    bash "$SCRIPT_DIR/system/install_packages.sh" list
}

# Удаление приложения
uninstall_app() {
    echo ""
    read -p "Введите имя пакета для удаления: " package_name
    bash "$SCRIPT_DIR/system/install_packages.sh" uninstall "$package_name"
}

# Запуск Docker
run_docker() {
    echo ""
    print_info "Проверка Docker..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker не установлен"
        echo "Установите Docker с https://www.docker.com"
        return 1
    fi
    
    echo "Команды Docker:"
    echo "1) Сборка образа"
    echo "2) Запуск контейнера"
    echo "3) Docker Compose"
    echo ""
    read -p "Выберите (1-3): " docker_choice
    
    case $docker_choice in
        1)
            print_info "Сборка Docker образа..."
            docker build -f "$SCRIPT_DIR/build/Dockerfile" -t ibo-phone:latest "$SCRIPT_DIR"
            print_success "Образ собран: ibo-phone:latest"
            ;;
        2)
            print_info "Запуск контейнера..."
            docker run -it -v "$SCRIPT_DIR:/ibo-phone-iso" ibo-phone:latest bash
            ;;
        3)
            print_info "Запуск Docker Compose..."
            docker-compose -f "$SCRIPT_DIR/build/docker-compose.yml" up -d
            print_success "Контейнеры запущены"
            ;;
        *)
            print_error "Неверный выбор"
            ;;
    esac
}

# Информация о проекте
show_project_info() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "                 IBO Phone ISO"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Версия: 1.0.0"
    echo "Архитектура: ARM64"
    echo "Kernel: Linux 5.15.0+"
    echo "Память: 2GB RAM"
    echo "Хранилище: 32GB"
    echo ""
    echo "Основные компоненты:"
    echo "  • IBO App Store - магазин приложений"
    echo "  • IBO Browser - веб-браузер"
    echo "  • Package Manager - менеджер пакетов APK/AAB"
    echo ""
    echo "Функции:"
    echo "  • Установка приложений (APK и AAB)"
    echo "  • Веб-браузер с JavaScript"
    echo "  • SELinux безопасность"
    echo "  • Docker поддержка"
    echo ""
    echo "Быстрый старт:"
    echo "  1) bash install.sh  # запустить этот скрипт"
    echo "  2) Выберите '2' для подготовки системы"
    echo "  3) Выберите '3' для сборки ISO"
    echo "  4) ISO образ будет в build_output/ibo-phone-1.0.0.iso"
    echo ""
}

# Главная функция
main() {
    clear
    print_header
    
    # Проверка зависимостей
    if ! check_dependencies; then
        return 1
    fi
    
    show_system_info
    
    # Главный цикл
    while true; do
        show_menu
        read -p "Выберите действие (1-9): " choice
        
        case $choice in
            1) view_documentation ;;
            2) prepare_system ;;
            3) build_iso ;;
            4) install_app ;;
            5) list_apps ;;
            6) uninstall_app ;;
            7) run_docker ;;
            8) show_project_info ;;
            9) 
                print_success "До свидания!"
                exit 0
                ;;
            *)
                print_error "Неверный выбор. Попробуйте снова."
                ;;
        esac
        
        read -p "Нажмите Enter для продолжения..."
    done
}

# Запуск программы
main "$@"
