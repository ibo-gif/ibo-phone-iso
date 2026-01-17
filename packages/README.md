# IBO Phone Package Examples
# Примеры пакетов APK и AAB для IBO Phone

## Встроенные приложения

### 1. IBO App Store
- **Имя**: com.ibo.appstore
- **Версия**: 1.0.0
- **Описание**: Магазин приложений для установки и управления пакетами
- **Формат**: APK
- **Размер**: ~5 MB
- **Функции**:
  - Просмотр доступных приложений
  - Установка APK пакетов
  - Установка AAB пакетов
  - Управление установленными приложениями
  - Обновление приложений

### 2. IBO Browser
- **Имя**: com.ibo.browser
- **Версия**: 1.0.0
- **Описание**: Веб-браузер для просмотра интернета
- **Формат**: APK
- **Размер**: ~8 MB
- **Функции**:
  - Просмотр веб-сайтов
  - Навигация (назад, вперед, обновить)
  - Поддержка JavaScript
  - История посещений
  - Закладки
  - Управление кэшем

### 3. Camera (Камера)
- **Имя**: com.ibo.camera
- **Версия**: 1.0.0
- **Описание**: Приложение для съемки фото и видео
- **Формат**: APK
- **Размер**: ~3 MB

### 4. Gallery (Галерея)
- **Имя**: com.ibo.gallery
- **Версия**: 1.0.0
- **Описание**: Управление фото и видео
- **Формат**: APK
- **Размер**: ~4 MB

### 5. Contacts (Контакты)
- **Имя**: com.ibo.contacts
- **Версия**: 1.0.0
- **Описание**: Справочник контактов
- **Формат**: APK
- **Размер**: ~2 MB

## Структура APK

```
app.apk
├── AndroidManifest.xml
├── classes.dex
├── resources.arsc
├── lib/
│   ├── arm64-v8a/
│   │   ├── libc++_shared.so
│   │   └── libapp.so
│   └── armeabi-v7a/
├── assets/
├── res/
│   ├── drawable/
│   ├── layout/
│   ├── values/
│   └── menu/
└── META-INF/
    ├── MANIFEST.MF
    ├── CERT.SF
    └── CERT.RSA
```

## Структура AAB

```
app.aab
├── BundleConfig.pb
├── base/
│   ├── manifest/
│   │   └── AndroidManifest.xml
│   ├── dex/
│   │   └── classes.dex
│   ├── lib/
│   │   ├── arm64-v8a/
│   │   ├── armeabi-v7a/
│   │   ├── x86/
│   │   └── x86_64/
│   ├── res/
│   ├── assets/
│   └── root/
├── dynamic_feature_modules/
│   └── module1/
└── BundleModules.xml
```

## Установка пакетов

### Установка APK
```bash
# Скопировать APK в директорию пакетов
cp myapp.apk /workspaces/ibo-phone-iso/packages/apk/

# Или использовать инсталлятор
bash /workspaces/ibo-phone-iso/system/install_packages.sh install-apk myapp.apk com.example.myapp
```

### Установка AAB
```bash
# Скопировать AAB в директорию пакетов
cp myapp.aab /workspaces/ibo-phone-iso/packages/aab/

# Или использовать инсталлятор
bash /workspaces/ibo-phone-iso/system/install_packages.sh install-aab myapp.aab com.example.myapp
```

## Сборка ISO

```bash
# Перейти в директорию проекта
cd /workspaces/ibo-phone-iso

# Сделать скрипт исполняемым
chmod +x build/build.sh

# Запустить сборку
bash build/build.sh
```

## Особенности

- **Архитектура**: ARM64 (поддержка ARMv8)
- **ОС**: Linux kernel 5.15+
- **Оборудование**: 2GB RAM, 32GB Storage
- **API уровень**: 31
- **Поддержка форматов**: APK, AAB
- **Функции безопасности**: SELinux, Verified Boot, Шифрование
