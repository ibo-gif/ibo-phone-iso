package com.ibo.appstore;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import androidx.core.content.FileProvider;
import java.io.File;

/**
 * Инсталлятор пакетов APK и AAB
 */
public class PackageInstaller {
    
    private Context context;
    private static final String APK_DIR = "/system/app/";
    private static final String AAB_DIR = "/system/app/bundles/";
    
    public PackageInstaller(Context context) {
        this.context = context;
    }
    
    /**
     * Установка APK пакета
     * @param apkFileName имя файла APK
     */
    public void installAPK(String apkFileName) {
        File apkFile = new File(APK_DIR, apkFileName);
        
        if (!apkFile.exists()) {
            throw new RuntimeException("APK файл не найден: " + apkFileName);
        }
        
        Intent intent = new Intent(Intent.ACTION_VIEW);
        Uri uri;
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            uri = FileProvider.getUriForFile(context, 
                "com.ibo.appstore.fileprovider", apkFile);
            intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        } else {
            uri = Uri.fromFile(apkFile);
        }
        
        intent.setDataAndType(uri, "application/vnd.android.package-archive");
        context.startActivity(intent);
    }
    
    /**
     * Установка AAB (Android App Bundle) пакета
     * @param aabFileName имя файла AAB
     */
    public void installAAB(String aabFileName) {
        File aabFile = new File(AAB_DIR, aabFileName);
        
        if (!aabFile.exists()) {
            throw new RuntimeException("AAB файл не найден: " + aabFileName);
        }
        
        // AAB требует разделения на APK через bundletool
        String[] apkFiles = extractAPKsFromAAB(aabFile);
        
        for (String apkFile : apkFiles) {
            installAPK(apkFile);
        }
    }
    
    /**
     * Извлечение APK из AAB
     * @param aabFile файл AAB
     * @return массив имен APK файлов
     */
    private String[] extractAPKsFromAAB(File aabFile) {
        // Использование bundletool для извлечения APK
        try {
            ProcessBuilder pb = new ProcessBuilder(
                "bundletool", "build-apks",
                "--bundle=" + aabFile.getAbsolutePath(),
                "--output=" + APK_DIR + "bundle.apks",
                "--mode=universal"
            );
            Process process = pb.start();
            process.waitFor();
            
            // Возвращаем основной APK
            return new String[]{"bundle_main.apk"};
        } catch (Exception e) {
            e.printStackTrace();
            return new String[]{};
        }
    }
    
    /**
     * Получение списка установленных приложений
     * @return массив имен пакетов
     */
    public String[] getInstalledApps() {
        File appDir = new File(APK_DIR);
        File[] files = appDir.listFiles((dir, name) -> name.endsWith(".apk"));
        
        if (files == null) {
            return new String[]{};
        }
        
        String[] appNames = new String[files.length];
        for (int i = 0; i < files.length; i++) {
            appNames[i] = files[i].getName();
        }
        
        return appNames;
    }
    
    /**
     * Удаление приложения
     * @param packageName имя пакета
     */
    public void uninstallApp(String packageName) {
        Intent intent = new Intent(Intent.ACTION_UNINSTALL_PACKAGE);
        intent.setData(Uri.parse("package:" + packageName));
        context.startActivity(intent);
    }
}
