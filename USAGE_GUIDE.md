# IBO Phone ISO - Руководство по использованию

## 📱 О системе

**IBO Phone ISO** - это полнофункциональная операционная система для мобильных телефонов на базе Linux с встроенными:
- **IBO App Store** - магазин приложений для установки APK и AAB пакетов
- **IBO Browser** - веб-браузер для просмотра интернета
- **Package Manager** - система управления пакетами

## 📦 Структура проекта

```
ibo-phone-iso/
├── README.md                 # Основная документация
├── apps/                     # Исходные коды приложений
│   ├── ibo-appstore/        # App Store (Java)
│   ├── ibo-browser/         # Browser (Java)
│   └── system-apps/         # Системные приложения
├── system/                  # Системные файлы
│   ├── boot.properties      # Параметры загрузки
│   ├── init.rc              # Скрипт инициализации
│   ├── package-manager.conf # Конфигурация менеджера пакетов
│   ├── install_packages.sh  # Инсталлятор пакетов
│   └── SystemService.java   # Основной сервис
├── kernel/                  # Конфигурация Linux kernel
│   └── kernel.config        # Параметры kernel
├── packages/                # Пакеты приложений
│   ├── apk/                # Android Package files (.apk)
│   ├── aab/                # Android App Bundle files (.aab)
│   └── README.md           # Информация о пакетах
├── boot/                    # Boot partition
└── build/                   # Скрипты сборки
    ├── build.sh            # Основной скрипт сборки ISO
    ├── setup-vm.sh         # Настройка виртуальной машины
    ├── Dockerfile          # Docker конфигурация
    ├── docker-compose.yml  # Docker Compose
    └── AndroidManifest.xml # Манифест приложения
```

## 🚀 Быстрый старт

### 1. Подготовка системы

```bash
# Перейти в директорию проекта
cd /workspaces/ibo-phone-iso

# Сделать скрипты исполняемыми
chmod +x build/build.sh
chmod +x build/setup-vm.sh
chmod +x system/install_packages.sh

# Подготовить систему
bash build/setup-vm.sh
```

### 2. Добавление приложений

#### Добавление APK пакета

```bash
# Скопировать APK в директорию пакетов
cp /path/to/app.apk packages/apk/

# Или использовать инсталлятор
bash system/install_packages.sh install-apk /path/to/app.apk com.example.app
```

#### Добавление AAB пакета

```bash
# Скопировать AAB в директорию пакетов
cp /path/to/app.aab packages/aab/

# Или использовать инсталлятор
bash system/install_packages.sh install-aab /path/to/app.aab com.example.app
```

### 3. Сборка ISO образа

```bash
# Запустить скрипт сборки
bash build/build.sh

# ISO образ будет создан в: build_output/ibo-phone-1.0.0.iso
```

## 🐳 Использование Docker

### Сборка Docker образа

```bash
# Перейти в директорию проекта
cd /workspaces/ibo-phone-iso

# Сборка образа
docker build -f build/Dockerfile -t ibo-phone:latest .
```

### Запуск контейнера

```bash
# Простой запуск
docker run -it -v /workspaces/ibo-phone-iso:/ibo-phone-iso ibo-phone:latest

# Или использовать Docker Compose
docker-compose -f build/docker-compose.yml up -d
```

### Сборка ISO в Docker

```bash
# Запустить контейнер и собрать ISO
docker run -it -v /workspaces/ibo-phone-iso:/ibo-phone-iso ibo-phone:latest bash build/build.sh
```

## 📋 Команды инсталлятора пакетов

```bash
# Установка APK
bash system/install_packages.sh install-apk <файл> <имя_пакета>

# Установка AAB
bash system/install_packages.sh install-aab <файл> <имя_пакета>

# Удаление пакета
bash system/install_packages.sh uninstall <имя_пакета>

# Список установленных пакетов
bash system/install_packages.sh list

# Справка
bash system/install_packages.sh help
```

## 🛠️ Компиляция приложений

### Компиляция App Store

```bash
javac -d build/output apps/ibo-appstore/*.java
```

### Компиляция Browser

```bash
javac -d build/output apps/ibo-browser/*.java
```

## ⚙️ Конфигурация системы

### Параметры загрузки (system/boot.properties)

```properties
os.version=1.0.0
os.name=IBO Phone OS
memory.ram.mb=2048
memory.storage.gb=32
display.width=1080
display.height=2340
```

### Конфигурация менеджера пакетов (system/package-manager.conf)

```ini
install_dir=/data/app
supported_formats=apk,aab
max_package_size=500
verify_signature=true
```

## 📊 Системные требования

- **Архитектура**: ARM64 (ARMv8+)
- **Процессор**: 4 ядра минимум
- **Памяти**: 2GB RAM
- **Хранилище**: 32GB
- **Kernel**: Linux 5.15.0+
- **ОС**: Ubuntu 22.04+, Debian, CentOS

## 🔒 Функции безопасности

- **SELinux**: Строгий контроль доступа
- **Verified Boot**: Проверка целостности
- **Шифрование**: AES-256
- **Подпись пакетов**: Верификация цифровой подписи
- **Разрешения**: Система разрешений приложений

## 🌐 Встроенные приложения

### IBO App Store
- Просмотр доступных приложений
- Установка APK пакетов
- Установка AAB пакетов
- Управление приложениями
- Автоматические обновления

### IBO Browser
- Просмотр веб-сайтов
- Поддержка JavaScript
- История посещений
- Закладки
- Управление кэшем
- Частная сеть (VPN)

## 🔧 Устранение неполадок

### Ошибка: "ISO инструменты не установлены"

```bash
# Ubuntu/Debian
sudo apt-get install cdrtools genisoimage

# CentOS/RHEL
sudo yum install mkisofs genisoimage

# macOS
brew install cdrtools
```

### Ошибка: "APK файл не найден"

```bash
# Убедитесь, что файл находится в правильной директории
ls -la packages/apk/

# Или скопируйте файл явно
cp /path/to/app.apk packages/apk/app.apk
```

### Ошибка: "Недостаточно свободного места"

```bash
# Проверка свободного места
df -h

# Очистка кэша
rm -rf /cache/app/*
```

## 📝 Примеры использования

### Пример 1: Создание простого APK приложения

```bash
# 1. Создайте исходный код Java
mkdir -p apps/my-app/src
echo 'public class MyApp { public static void main(String[] args) { } }' > apps/my-app/src/MyApp.java

# 2. Скомпилируйте
javac -d apps/my-app/bin apps/my-app/src/MyApp.java

# 3. Создайте APK
# (Требуется Android SDK build tools)
aapt package -f -m -J apps/my-app/bin -S apps/my-app/res -I /path/to/android.jar -M apps/my-app/AndroidManifest.xml

# 4. Установите
bash system/install_packages.sh install-apk apps/my-app/bin/app.apk com.example.myapp
```

### Пример 2: Добавление собственного браузера

```bash
# 1. Модифицируйте Browser.java
# 2. Скомпилируйте
javac -d build/output apps/ibo-browser/Browser.java

# 3. Соберите APK
# 4. Добавьте в пакеты
cp build/output/ibo-browser.apk packages/apk/
```

## 📚 Дополнительные ресурсы

- [Android Developer Documentation](https://developer.android.com/)
- [Linux Kernel Documentation](https://kernel.org/doc/)
- [Android App Bundle Guide](https://developer.android.com/guide/app-bundle)

## 📄 Лицензия

IBO Phone ISO System © 2026
Все права защищены.

## 👨‍💻 Разработка

Для внесения изменений в исходный код:

1. Отредактируйте файлы в `apps/` или `system/`
2. Перекомпилируйте: `bash build/build.sh`
3. Протестируйте на виртуальной машине
4. Создайте ISO образ

## 📞 Поддержка

Для получения помощи:
- Проверьте раздел "Устранение неполадок"
- Прочитайте документацию в [README.md](README.md)
- Проверьте логи: `/var/log/package_installer.log`

---

**IBO Phone ISO - мобильная ОС нового поколения!**
