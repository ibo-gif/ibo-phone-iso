#!/bin/bash

# IBO Phone Virtual Machine Setup
# Скрипт настройки виртуальной машины для IBO Phone

set -e

echo "========================================="
echo "IBO Phone VM Setup"
echo "========================================="

# Проверка зависимостей
echo "Проверка зависимостей..."

REQUIRED_TOOLS=("java" "javac" "bash" "df")
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "ОШИБКА: $tool не установлен"
        exit 1
    fi
done

echo "✓ Все зависимости установлены"

# Получение информации о ОС
echo ""
echo "Информация о системе:"
echo "- OS: $(uname -s)"
echo "- Архитектура: $(uname -m)"
echo "- Java версия: $(java -version 2>&1 | head -1)"

# Создание необходимых директорий
echo ""
echo "Создание системных директорий..."

mkdir -p /data/{app,app-lib,cache,local}
mkdir -p /system/{app,lib,bin,etc,fonts}
mkdir -p /cache/app

echo "✓ Директории созданы"

# Установка прав доступа
echo ""
echo "Установка прав доступа..."

chmod 755 /data
chmod 755 /system
chmod 755 /cache

echo "✓ Права доступа установлены"

# Загрузка конфигурации
echo ""
echo "Загрузка конфигурации системы..."

if [ -f "system/boot.properties" ]; then
    source system/boot.properties
    echo "✓ Конфигурация загружена"
    echo "  - ОС: $os.name v$os.version"
    echo "  - Памяти: ${memory.ram.mb}MB"
else
    echo "⚠ Файл конфигурации не найден"
fi

echo ""
echo "========================================="
echo "✓ Виртуальная машина готова к запуску!"
echo "========================================="
echo ""
echo "Для сборки ISO используйте:"
echo "  bash build/build.sh"
echo ""
echo "Для установки приложений используйте:"
echo "  bash system/install_packages.sh install-apk <file> <package>"
echo "  bash system/install_packages.sh install-aab <file> <package>"
