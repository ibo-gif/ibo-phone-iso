# IBO Phone - Примеры использования

## 📱 Примеры кода

### Пример 1: Использование App Store

```java
// Создание экземпляра App Store
AppStore appStore = new AppStore();

// Получение списка доступных приложений
List<AppInfo> apps = appStore.getAvailableApps();

// Установка приложения
AppInfo browserApp = apps.stream()
    .filter(app -> app.getName().equals("IBO Browser"))
    .findFirst()
    .orElse(null);

if (browserApp != null) {
    appStore.installApp(browserApp);
}

// Проверка установленных приложений
String[] installedApps = appStore.getInstalledApps();
for (String app : installedApps) {
    System.out.println("Установлено: " + app);
}
```

### Пример 2: Установка APK через Package Installer

```java
import com.ibo.appstore.PackageInstaller;

public class MyInstaller {
    public static void main(String[] args) {
        Context context = getApplicationContext();
        PackageInstaller installer = new PackageInstaller(context);
        
        // Установка APK
        installer.installAPK("myapp.apk");
        
        // Проверка установки
        String[] apps = installer.getInstalledApps();
        System.out.println("Всего приложений: " + apps.length);
    }
}
```

### Пример 3: Использование Browser

```java
import com.ibo.browser.Browser;

public class BrowserExample {
    public static void main(String[] args) {
        Browser browser = new Browser();
        
        // Загрузка веб-сайта
        browser.loadUrl("https://example.com");
        
        // Вперед
        if (browser.canGoForward()) {
            browser.goForward();
        }
        
        // Назад
        if (browser.canGoBack()) {
            browser.goBack();
        }
        
        // Обновить
        browser.reload();
    }
}
```

## 🚀 Практические примеры

### Пример 1: Установка приложения через командную строку

```bash
#!/bin/bash

# Установка браузера (APK)
bash /workspaces/ibo-phone-iso/system/install_packages.sh \
    install-apk /path/to/chrome.apk com.android.chrome

# Результат:
# [2026-01-17 10:30:45] Установка APK: com.android.chrome
# [2026-01-17 10:30:46] ✓ APK успешно установлен: com.android.chrome
```

### Пример 2: Установка AAB приложения

```bash
#!/bin/bash

# Установка приложения (AAB)
bash /workspaces/ibo-phone-iso/system/install_packages.sh \
    install-aab /path/to/gmail.aab com.google.android.gm

# Результат:
# [2026-01-17 10:31:10] Установка AAB: com.google.android.gm
# [2026-01-17 10:31:15] ✓ AAB конвертирован в APKS
# [2026-01-17 10:31:20] ✓ AAB успешно установлен: com.google.android.gm
```

### Пример 3: Список установленных приложений

```bash
#!/bin/bash

# Получение списка приложений
bash /workspaces/ibo-phone-iso/system/install_packages.sh list

# Результат:
# Список установленных пакетов:
# === APK пакеты ===
# chrome.apk
# gmail.apk
# maps.apk
# === AAB пакеты ===
# youtube.aab
```

### Пример 4: Удаление приложения

```bash
#!/bin/bash

# Удаление приложения
bash /workspaces/ibo-phone-iso/system/install_packages.sh \
    uninstall com.example.app

# Результат:
# [2026-01-17 10:32:00] Удаление пакета: com.example.app
# [2026-01-17 10:32:01] ✓ Пакет удален: com.example.app
```

## 🔧 Расширенные примеры

### Пример 1: Автоматическая установка нескольких приложений

```bash
#!/bin/bash

# Скрипт для установки набора приложений

INSTALLER="/workspaces/ibo-phone-iso/system/install_packages.sh"
APPS_DIR="/path/to/my/apps"

# Функция установки приложения
install_app() {
    local file=$1
    local package=$2
    
    if [ -f "$file" ]; then
        echo "Установка: $package"
        bash "$INSTALLER" install-apk "$file" "$package"
    else
        echo "⚠ Файл не найден: $file"
    fi
}

# Установка приложений
install_app "$APPS_DIR/chrome.apk" "com.android.chrome"
install_app "$APPS_DIR/firefox.apk" "org.mozilla.firefox"
install_app "$APPS_DIR/maps.apk" "com.google.android.apps.maps"

echo "✓ Все приложения установлены!"
```

### Пример 2: Создание собственного приложения для App Store

```java
package com.example.myapp;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class MyApp extends Activity {
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        TextView textView = findViewById(R.id.text);
        textView.setText("Добро пожаловать в IBO Phone!");
    }
}
```

### Пример 3: Интеграция с Package Manager

```java
import com.ibo.appstore.PackageInstaller;
import android.content.Context;

public class PackageManager {
    
    private PackageInstaller installer;
    
    public PackageManager(Context context) {
        installer = new PackageInstaller(context);
    }
    
    // Массовая установка
    public void installBatch(String[] apkFiles) {
        for (int i = 0; i < apkFiles.length; i++) {
            try {
                installer.installAPK(apkFiles[i]);
                System.out.println("✓ Установлено: " + apkFiles[i]);
            } catch (Exception e) {
                System.err.println("✗ Ошибка установки: " + e.getMessage());
            }
        }
    }
    
    // Проверка версии приложения
    public String getAppVersion(String packageName) {
        // Получение версии из установленного приложения
        return "1.0.0";
    }
    
    // Обновление приложения
    public void updateApp(String packageName, String newApkPath) {
        uninstall(packageName);
        installer.installAPK(newApkPath);
    }
    
    private void uninstall(String packageName) {
        installer.uninstallApp(packageName);
    }
}
```

## 📊 Примеры конфигурации

### Пример 1: Кастомные параметры boot

```properties
# custom-boot.properties

# Пользовательские параметры
os.version=1.0.1
device.name=IBO Phone Pro
device.model=IPP-2026

# Параметры сети
network.wifi.name=IBO_Network
network.wifi.security=WPA2

# Параметры дисплея (для различных моделей)
display.width=1440
display.height=3120
display.dpi=512

# Параметры производительности
performance.boost=true
performance.gpu_acceleration=true

# Параметры разработчика
developer.usb_debugging=true
developer.performance_monitoring=true
```

### Пример 2: Расширенная конфигурация Package Manager

```ini
# extended-package-manager.conf

[Advanced]
parallel_install=true
max_concurrent_installs=3
install_timeout=300
auto_cleanup_cache=true
cleanup_after_days=30

[Networking]
use_proxy=false
proxy_address=
proxy_port=
download_retry=5
connection_timeout=60

[Storage]
install_dir=/data/app
cache_dir=/cache/app
backup_dir=/data/backup
min_free_space_mb=200

[Verification]
check_manifest_validity=true
validate_dex_files=true
verify_native_libs=true
check_resource_integrity=true

[Logging]
log_level=INFO
log_file=/var/log/package_manager.log
max_log_size_mb=10
log_rotation=true
```

## 🎯 Сценарии использования

### Сценарий 1: Первоначальная настройка системы

```bash
#!/bin/bash

# 1. Подготовка ВМ
bash build/setup-vm.sh

# 2. Установка встроенных приложений
bash system/install_packages.sh install-apk packages/apk/ibo-browser.apk com.ibo.browser
bash system/install_packages.sh install-apk packages/apk/ibo-appstore.apk com.ibo.appstore

# 3. Проверка установки
bash system/install_packages.sh list

# 4. Сборка ISO
bash build/build.sh

echo "✓ Система готова!"
```

### Сценарий 2: Разработка и тестирование приложения

```bash
#!/bin/bash

# 1. Разработка приложения
javac -d build/output src/MyApp.java

# 2. Создание APK
# (Использование Android build tools)

# 3. Установка на систему
bash system/install_packages.sh install-apk build/output/myapp.apk com.example.myapp

# 4. Тестирование
echo "Приложение установлено и готово к тестированию"

# 5. Удаление для переустановки
bash system/install_packages.sh uninstall com.example.myapp
```

## 📚 Дополнительные материалы

### Файлы документации
- [README.md](README.md) - Основная документация
- [USAGE_GUIDE.md](USAGE_GUIDE.md) - Руководство пользователя
- [SPECIFICATION.md](SPECIFICATION.md) - Полная спецификация системы

### Исходные коды
- [AppStore.java](apps/ibo-appstore/AppStore.java) - Магазин приложений
- [Browser.java](apps/ibo-browser/Browser.java) - Веб-браузер
- [PackageInstaller.java](apps/ibo-appstore/PackageInstaller.java) - Инсталлятор пакетов

### Скрипты сборки
- [build.sh](build/build.sh) - Основной скрипт сборки ISO
- [setup-vm.sh](build/setup-vm.sh) - Подготовка виртуальной машины
- [install_packages.sh](system/install_packages.sh) - Инсталлятор пакетов

---

**IBO Phone - мобильная ОС нового поколения!**
