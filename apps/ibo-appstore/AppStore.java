package com.ibo.appstore;

import android.app.Activity;
import android.os.Bundle;
import android.widget.GridView;
import android.widget.ArrayAdapter;
import java.util.ArrayList;
import java.util.List;

/**
 * IBO Phone App Store
 * Магазин приложений для установки и управления APK и AAB пакетами
 */
public class AppStore extends Activity {
    
    private GridView appGrid;
    private List<AppInfo> availableApps;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_appstore);
        
        appGrid = findViewById(R.id.app_grid);
        initializeApps();
        setupAppGrid();
    }
    
    /**
     * Инициализация доступных приложений
     */
    private void initializeApps() {
        availableApps = new ArrayList<>();
        // Предустановленные приложения
        availableApps.add(new AppInfo("IBO Browser", "com.ibo.browser", "1.0", "IBO Browser - веб-браузер", "browser.apk"));
        availableApps.add(new AppInfo("Камера", "com.ibo.camera", "1.0", "Встроенная камера", "camera.apk"));
        availableApps.add(new AppInfo("Галерея", "com.ibo.gallery", "1.0", "Управление фото", "gallery.apk"));
        availableApps.add(new AppInfo("Контакты", "com.ibo.contacts", "1.0", "Справочник контактов", "contacts.apk"));
        
        // Популярные игры и приложения
        availableApps.add(new AppInfo("Roblox", "com.roblox.client", "2.543.617", "Play any game you can imagine - Roblox", "roblox.apk"));
        availableApps.add(new AppInfo("YouTube", "com.google.android.youtube", "18.01.39", "Смотри видео YouTube", "youtube.apk"));
        availableApps.add(new AppInfo("Chrome", "com.android.chrome", "96.0.4664", "Веб-браузер Google Chrome", "chrome.apk"));
        availableApps.add(new AppInfo("Telegram", "org.telegram.messenger", "8.4.1", "Быстрый мессенджер Telegram", "telegram.apk"));
        availableApps.add(new AppInfo("Discord", "com.discord", "157.10", "Talk, Chat, Hang Out", "discord.apk"));
        availableApps.add(new AppInfo("Minecraft", "com.mojang.minecraftpe", "1.19.60", "Откройте для себя миры Minecraft", "minecraft.apk"));
        availableApps.add(new AppInfo("TikTok", "com.zhiliaoapp.musically", "35.2.1", "Самое интересное видео", "tiktok.apk"));
        availableApps.add(new AppInfo("Instagram", "com.instagram.android", "288.0.0", "Социальная сеть Instagram", "instagram.apk"));
    }
    
    /**
     * Настройка сетки приложений
     */
    private void setupAppGrid() {
        AppStoreAdapter adapter = new AppStoreAdapter(this, availableApps);
        appGrid.setAdapter(adapter);
        
        appGrid.setOnItemClickListener((parent, view, position, id) -> {
            AppInfo selectedApp = availableApps.get(position);
            installApp(selectedApp);
        });
    }
    
    /**
     * Установка приложения
     * @param appInfo информация о приложении
     */
    private void installApp(AppInfo appInfo) {
        PackageInstaller installer = new PackageInstaller(this);
        if (appInfo.getFileName().endsWith(".apk")) {
            installer.installAPK(appInfo.getFileName());
        } else if (appInfo.getFileName().endsWith(".aab")) {
            installer.installAAB(appInfo.getFileName());
        }
    }
    
    /**
     * Информация о приложении
     */
    public static class AppInfo {
        private String name;
        private String packageName;
        private String version;
        private String description;
        private String fileName;
        
        public AppInfo(String name, String packageName, String version, 
                      String description, String fileName) {
            this.name = name;
            this.packageName = packageName;
            this.version = version;
            this.description = description;
            this.fileName = fileName;
        }
        
        // Getters
        public String getName() { return name; }
        public String getPackageName() { return packageName; }
        public String getVersion() { return version; }
        public String getDescription() { return description; }
        public String getFileName() { return fileName; }
    }
}
