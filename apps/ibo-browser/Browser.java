package com.ibo.browser;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.EditText;
import android.widget.Button;
import android.widget.ProgressBar;
import android.view.KeyEvent;
import android.view.inputmethod.EditorInfo;

/**
 * IBO Phone Browser
 * Веб-браузер для просмотра интернета
 */
public class Browser extends Activity {
    
    private WebView webView;
    private EditText urlInput;
    private ProgressBar progressBar;
    private Button backButton;
    private Button forwardButton;
    private Button refreshButton;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_browser);
        
        initializeComponents();
        setupWebView();
        setupInputHandlers();
    }
    
    /**
     * Инициализация компонентов UI
     */
    private void initializeComponents() {
        webView = findViewById(R.id.webview);
        urlInput = findViewById(R.id.url_input);
        progressBar = findViewById(R.id.progress_bar);
        backButton = findViewById(R.id.btn_back);
        forwardButton = findViewById(R.id.btn_forward);
        refreshButton = findViewById(R.id.btn_refresh);
    }
    
    /**
     * Настройка WebView
     */
    private void setupWebView() {
        webView.setWebViewClient(new BrowserWebViewClient());
        
        // Включение JavaScript
        webView.getSettings().setJavaScriptEnabled(true);
        
        // Настройки DOM хранилища
        webView.getSettings().setDomStorageEnabled(true);
        
        // Загрузка домашней страницы
        webView.loadUrl("about:blank");
    }
    
    /**
     * Настройка обработчиков ввода
     */
    private void setupInputHandlers() {
        // Кнопка "Назад"
        backButton.setOnClickListener(v -> {
            if (webView.canGoBack()) {
                webView.goBack();
            }
        });
        
        // Кнопка "Вперед"
        forwardButton.setOnClickListener(v -> {
            if (webView.canGoForward()) {
                webView.goForward();
            }
        });
        
        // Кнопка "Обновить"
        refreshButton.setOnClickListener(v -> webView.reload());
        
        // Ввод URL
        urlInput.setOnEditorActionListener((v, actionId, event) -> {
            if (actionId == EditorInfo.IME_ACTION_GO) {
                String url = urlInput.getText().toString();
                if (!url.startsWith("http://") && !url.startsWith("https://")) {
                    url = "https://" + url;
                }
                webView.loadUrl(url);
                return true;
            }
            return false;
        });
    }
    
    /**
     * Обработчик WebView
     */
    private class BrowserWebViewClient extends WebViewClient {
        
        @Override
        public void onPageStarted(WebView view, String url, android.graphics.Bitmap favicon) {
            super.onPageStarted(view, url, favicon);
            progressBar.setVisibility(ProgressBar.VISIBLE);
            urlInput.setText(url);
        }
        
        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            progressBar.setVisibility(ProgressBar.GONE);
            urlInput.setText(url);
        }
        
        @Override
        public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
            super.onReceivedError(view, errorCode, description, failingUrl);
            progressBar.setVisibility(ProgressBar.GONE);
            webView.loadUrl("about:blank");
        }
    }
    
    /**
     * Обработка кнопки "Назад"
     */
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK) && webView.canGoBack()) {
            webView.goBack();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }
}
