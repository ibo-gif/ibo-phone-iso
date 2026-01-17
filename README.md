# IBO Phone ISO System

Операционная система для телефона IBO с встроенным App Store и браузером.

## Компоненты системы

- **IBO App Store** - Магазин приложений
- **IBO Browser** - Веб-браузер  
- **Система управления пакетами** - Поддержка APK и AAB форматов

## Структура проекта

```
/
├── system/                 # Системные файлы
├── apps/                   # Встроенные приложения
│   ├── ibo-appstore/      # Магазин приложений
│   ├── ibo-browser/       # Браузер
│   └── system-apps/       # Системные приложения
├── packages/              # Пакеты приложений
│   ├── apk/              # Android Package (APK)
│   └── aab/              # Android App Bundle (AAB)
├── boot/                  # Boot partition
├── kernel/               # Linux kernel
└── build/                # Скрипты сборки
```

## Установка

Для установки APK и AAB пакетов используйте встроенный пакетный менеджер.

## Лицензия

IBO Phone ISO System © 2026
