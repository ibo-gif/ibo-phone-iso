#!/bin/bash

# IBO Phone Package Installer
# Инсталлятор пакетов APK и AAB для IBO Phone

set -e

INSTALL_DIR="/data/app"
CACHE_DIR="/cache/app"
APK_DIR="$INSTALL_DIR/apk"
AAB_DIR="$INSTALL_DIR/aab"
LOG_FILE="/var/log/package_installer.log"

# Функция логирования
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Функция проверки свободного места
check_free_space() {
    local required_space=$1
    local available=$(df "$INSTALL_DIR" | awk 'NR==2 {print $4}')
    
    if [ "$available" -lt "$required_space" ]; then
        log_message "ОШИБКА: Недостаточно свободного места (требуется: ${required_space}KB, доступно: ${available}KB)"
        return 1
    fi
    return 0
}

# Функция установки APK
install_apk() {
    local apk_file=$1
    local package_name=$2
    
    if [ ! -f "$apk_file" ]; then
        log_message "ОШИБКА: APK файл не найден: $apk_file"
        return 1
    fi
    
    log_message "Установка APK: $package_name"
    
    # Проверка размера пакета
    local file_size=$(stat -f%z "$apk_file" 2>/dev/null || stat -c%s "$apk_file")
    local required_space=$((file_size / 1024))
    
    check_free_space "$required_space" || return 1
    
    # Копирование файла
    mkdir -p "$APK_DIR"
    cp "$apk_file" "$APK_DIR/$package_name.apk"
    
    log_message "✓ APK успешно установлен: $package_name"
    return 0
}

# Функция установки AAB
install_aab() {
    local aab_file=$1
    local package_name=$2
    
    if [ ! -f "$aab_file" ]; then
        log_message "ОШИБКА: AAB файл не найден: $aab_file"
        return 1
    fi
    
    log_message "Установка AAB: $package_name"
    
    # Проверка наличия bundletool
    if ! command -v bundletool &> /dev/null; then
        log_message "ПРЕДУПРЕЖДЕНИЕ: bundletool не установлен, установка AAB в универсальном режиме"
        mkdir -p "$AAB_DIR"
        cp "$aab_file" "$AAB_DIR/$package_name.aab"
    else
        # Использование bundletool для конвертации AAB в APK
        local apks_file="$CACHE_DIR/${package_name}.apks"
        mkdir -p "$CACHE_DIR"
        
        bundletool build-apks \
            --bundle="$aab_file" \
            --output="$apks_file" \
            --mode=universal \
            --ks_pass=pass:123456
        
        log_message "✓ AAB конвертирован в APKS"
    fi
    
    log_message "✓ AAB успешно установлен: $package_name"
    return 0
}

# Функция удаления пакета
uninstall_package() {
    local package_name=$1
    
    log_message "Удаление пакета: $package_name"
    
    # Удаление APK
    rm -f "$APK_DIR/$package_name.apk"
    
    # Удаление AAB
    rm -f "$AAB_DIR/$package_name.aab"
    
    # Удаление кэша
    rm -f "$CACHE_DIR/${package_name}.apks"
    
    log_message "✓ Пакет удален: $package_name"
}

# Функция списка установленных пакетов
list_packages() {
    log_message "Список установленных пакетов:"
    echo "=== APK пакеты ==="
    ls -1 "$APK_DIR" 2>/dev/null || echo "Нет APK пакетов"
    echo "=== AAB пакеты ==="
    ls -1 "$AAB_DIR" 2>/dev/null || echo "Нет AAB пакетов"
}

# Главная функция
main() {
    case "${1:-help}" in
        install-apk)
            install_apk "$2" "$3"
            ;;
        install-aab)
            install_aab "$2" "$3"
            ;;
        uninstall)
            uninstall_package "$2"
            ;;
        list)
            list_packages
            ;;
        help)
            echo "IBO Phone Package Installer"
            echo ""
            echo "Использование:"
            echo "  $0 install-apk <файл> <имя_пакета>  - Установка APK"
            echo "  $0 install-aab <файл> <имя_пакета>  - Установка AAB"
            echo "  $0 uninstall <имя_пакета>           - Удаление пакета"
            echo "  $0 list                             - Список установленных пакетов"
            echo "  $0 help                             - Справка"
            ;;
        *)
            echo "ОШИБКА: Неизвестная команда: $1"
            exit 1
            ;;
    esac
}

# Инициализация
mkdir -p "$INSTALL_DIR" "$CACHE_DIR" "$APK_DIR" "$AAB_DIR"
log_message "IBO Phone Package Installer запущен"

# Запуск
main "$@"
