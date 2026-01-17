# IBO Phone ISO - Полная спецификация системы

## 🎯 Обзор

**IBO Phone ISO** - это полнофункциональная мобильная операционная система, разработанная на основе Linux с поддержкой установки и управления приложениями через магазин приложений.

## 📋 Основные компоненты

### 1. IBO App Store (Магазин приложений)

**Местоположение**: `apps/ibo-appstore/`

#### Файлы:
- `AppStore.java` - основной класс магазина приложений
- `PackageInstaller.java` - класс для установки APK и AAB пакетов

#### Функции:
```
✓ Просмотр каталога приложений
✓ Поиск приложений по названию
✓ Установка APK пакетов
✓ Установка AAB пакетов (через bundletool)
✓ Обновление приложений
✓ Удаление приложений
✓ Управление правами доступа
```

#### Архитектура:
```
AppStore (UI)
    ↓
PackageInstaller
    ├── APK Installer
    └── AAB Converter (bundletool)
        └── APK Installer
```

### 2. IBO Browser (Веб-браузер)

**Местоположение**: `apps/ibo-browser/`

#### Файлы:
- `Browser.java` - основной класс браузера

#### Функции:
```
✓ Просмотр веб-сайтов
✓ Поддержка HTTP/HTTPS протоколов
✓ JavaScript поддержка
✓ История посещений
✓ Закладки
✓ Управление кэшем
✓ DOM Storage
✓ Частная сеть
```

#### Интерфейс:
```
┌─────────────────────────────────┐
│ [←] [→] [⟳] [🔍] URL Input     │  Панель навигации
├─────────────────────────────────┤
│                                 │
│     Область отображения         │
│     веб-сайтов (WebView)        │
│                                 │
│                                 │
│                                 │
└─────────────────────────────────┘
```

### 3. Package Manager (Менеджер пакетов)

**Местоположение**: `system/`

#### Компоненты:

1. **package-manager.conf** - конфигурация
   ```ini
   [PackageManager]
   install_dir=/data/app
   supported_formats=apk,aab
   max_package_size=500
   
   [APK]
   format_version=2
   compression=enabled
   
   [AAB]
   bundletool_version=1.14.0
   universal_mode=enabled
   ```

2. **install_packages.sh** - инсталлятор пакетов
   ```bash
   Команды:
   - install-apk <файл> <пакет>
   - install-aab <файл> <пакет>
   - uninstall <пакет>
   - list
   ```

3. **SystemService.java** - основной системный сервис

### 4. Linux Kernel Configuration

**Местоположение**: `kernel/kernel.config`

#### Поддерживаемые функции:
```
✓ ARM64 архитектура (ARMv8)
✓ SMP (многопроцессорность)
✓ EXT4, SQUASHFS файловые системы
✓ WiFi и сетевая поддержка
✓ USB поддержка
✓ Мультимедиа (видео, аудио)
✓ Сенсорный экран
✓ SELinux безопасность
✓ Криптография (AES, SHA256)
```

## 🏗️ Структура директорий

```
ibo-phone-iso/
│
├── README.md                          # Основная документация
├── USAGE_GUIDE.md                    # Руководство пользователя
├── SPECIFICATION.md                  # Этот файл
│
├── apps/                             # Исходные коды приложений
│   ├── ibo-appstore/                # Магазин приложений (Java)
│   │   ├── AppStore.java
│   │   └── PackageInstaller.java
│   ├── ibo-browser/                 # Веб-браузер (Java)
│   │   └── Browser.java
│   └── system-apps/                 # Системные приложения
│
├── system/                           # Системные файлы
│   ├── boot.properties               # Параметры загрузки
│   ├── init.rc                       # Скрипт инициализации Init
│   ├── package-manager.conf          # Конфигурация менеджера пакетов
│   ├── install_packages.sh           # Скрипт установки пакетов
│   └── SystemService.java            # Основной системный сервис
│
├── kernel/                           # Конфигурация Linux kernel
│   └── kernel.config                 # Параметры kernel 5.15.0
│
├── packages/                         # Репозиторий пакетов приложений
│   ├── README.md                     # Документация пакетов
│   ├── apk/                          # APK пакеты
│   │   └── [приложения.apk]
│   └── aab/                          # AAB пакеты
│       └── [приложения.aab]
│
├── boot/                             # Boot partition
│   └── [загрузчик, ядро]
│
└── build/                            # Инструменты сборки
    ├── build.sh                      # Основной скрипт сборки ISO
    ├── setup-vm.sh                   # Подготовка ВМ
    ├── Dockerfile                    # Docker конфигурация
    ├── docker-compose.yml            # Docker Compose
    └── AndroidManifest.xml           # Манифест приложения
```

## ⚙️ Параметры системы

### boot.properties
```properties
os.version=1.0.0
os.name=IBO Phone OS
os.brand=IBO
kernel.version=5.15.0
kernel.arch=arm64
memory.ram.mb=2048
memory.storage.gb=32
display.width=1080
display.height=2340
display.dpi=420
```

### init.rc (Init скрипты)
```
Сервисы:
- bootanim         - анимация загрузки
- appstore         - фоновый сервис App Store
- browser          - фоновый сервис Browser
- package_manager  - менеджер пакетов
- installer        - сервис установки
```

## 📦 Форматы пакетов

### APK (Android Package)
```
app.apk
├── AndroidManifest.xml        # Описание приложения
├── classes.dex                # Скомпилированный Java код
├── resources.arsc             # Ресурсы приложения
├── lib/                       # Нативные библиотеки
│   └── arm64-v8a/            # ARM64 библиотеки
├── assets/                    # Ассеты приложения
├── res/                       # Ресурсы (drawable, layout и т.д.)
└── META-INF/                 # Метаинформация и подпись
    ├── MANIFEST.MF
    ├── CERT.SF
    └── CERT.RSA
```

### AAB (Android App Bundle)
```
app.aab
├── BundleConfig.pb           # Конфигурация бандла
├── base/                     # Базовый модуль
│   ├── manifest/
│   ├── dex/
│   ├── lib/
│   ├── res/
│   └── assets/
├── dynamic_feature_modules/  # Динамические модули
└── BundleModules.xml
```

## 🔄 Процесс установки приложений

### Установка APK

```
┌─────────────────────────────────┐
│ Выбор APK из магазина           │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ Проверка цифровой подписи       │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ Проверка свободного места       │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ Запрос разрешений               │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ Установка файлов                │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ ✓ Приложение установлено        │
└─────────────────────────────────┘
```

### Установка AAB

```
┌─────────────────────────────────┐
│ Выбор AAB из магазина           │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ Проверка bundletool             │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ Конвертация AAB → APKS          │
│ (universal mode)                │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ Извлечение главного APK         │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ Установка как APK               │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ ✓ Приложение установлено        │
└─────────────────────────────────┘
```

## 🔐 Система безопасности

### Уровни защиты

1. **Boot Level**
   - Verified Boot (проверка целостности)
   - Secure Boot (защищенная загрузка)

2. **Kernel Level**
   - SELinux (принудительное управление доступом)
   - Мандатное управление доступом (MAC)

3. **Application Level**
   - Система разрешений приложений
   - Подпись приложений (APK signing)
   - Изоляция приложений (sandbox)

4. **Data Level**
   - AES-256 шифрование
   - SHA-256 хеширование
   - Защита хранилища данных

## 📊 Производительность

### Требования

| Параметр | Минимум | Рекомендуемо |
|----------|---------|-------------|
| CPU | ARM64 v8 | ARM64 v8+ (4 ядра) |
| RAM | 1GB | 2GB+ |
| Storage | 8GB | 32GB+ |
| Kernel | 5.10 | 5.15+ |
| Display | 720x1280 | 1080x2340 |

### Оптимизация

```properties
CONFIG_HZ_1000=y          # 1000Hz timer
CONFIG_NR_CPUS=4          # 4 CPU cores
CONFIG_SMP=y              # Multi-core support
CONFIG_CPU_FREQ=y         # Dynamic CPU scaling
CONFIG_THERMAL=y          # Thermal management
```

## 🛠️ Команды сборки

### Подготовка
```bash
cd /workspaces/ibo-phone-iso
chmod +x build/*.sh
chmod +x system/*.sh
bash build/setup-vm.sh
```

### Сборка ISO
```bash
bash build/build.sh
```

### Docker
```bash
docker build -f build/Dockerfile -t ibo-phone:latest .
docker run -it ibo-phone:latest bash build/build.sh
```

## 🌐 Сетевые функции

- **WiFi**: IEEE 802.11 a/b/g/n/ac
- **Bluetooth**: 5.0+ поддержка
- **NFC**: Near Field Communication
- **IPv4/IPv6**: Поддержка обоих протоколов
- **DNS**: DHCP и статическая конфигурация

## 🎮 Мультимедиа

- **Видео кодеки**: H.264, H.265 (HEVC)
- **Аудио кодеки**: AAC, MP3, OPUS
- **Изображения**: PNG, JPEG, WebP
- **Частота кадров**: 30-60 FPS

## 📝 Версионирование

```
IBO Phone OS v1.0.0
├── Major (1) - Основные функции
├── Minor (0) - Новые возможности
└── Patch (0) - Исправления ошибок
```

## 📄 Лицензия

IBO Phone ISO System © 2026
Все права защищены.

---

**IBO Phone - мобильная ОС нового поколения!**
