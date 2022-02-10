package com.example.mediagrabber;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;

import androidx.annotation.NonNull;

import com.example.mediagrabber.Grabber.ContentSearch;
import com.example.mediagrabber.Utils.Utils;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSocketFactory;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/grabber";
    private SSLSocketFactory defaultSSLSF;
    Context mContext;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        defaultSSLSF = HttpsURLConnection.getDefaultSSLSocketFactory();
        mContext = this;

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            if (call.method.equals("getBatteryLevel")) {
                                int batteryLevel = getBatteryLevel();

                                if (batteryLevel != -1) {
                                    result.success(batteryLevel);
                                } else {
                                    result.error("UNAVAILABLE", "Battery level not available.", null);
                                }
                            } else if (call.method.equals("grabMedia")) {
                                String url = "", viewUrl = "", title = "";

                                try {
                                    url = call.argument("url");
                                    viewUrl = call.argument("viewUrl");
                                    title = call.argument("title");
                                } catch (Exception e) {
                                    result.error("UNAVAILABLE", "Can't get arguments", null);
                                    System.out.println(e);
                                }

//                                result.success(url + " " + viewUrl + " " + title);
                                new ContentSearch(mContext, url, viewUrl, title) {
                                    @Override
                                    public void onStartInspectingURL() {
                                        Utils.disableSSLCertificateChecking();
                                    }

                                    @Override
                                    public void onFinishedInspectingURL(boolean finishedAll) {
                                        HttpsURLConnection.setDefaultSSLSocketFactory(defaultSSLSF);
                                    }

                                    @Override
                                    public void onVideoFound(String size, String type, String link, String name, String page, boolean chunked, String website, boolean audio) {
                                        result.success("video " + link);
                                    }

                                    @Override
                                    public void onImageFound(String size, String type, String link, String name, String page, boolean chunked, String website, boolean audio) {
                                        result.success("image " + link);
                                    }

                                    @Override
                                    public void onAudioFound(String size, String type, String link, String name, String page, boolean chunked, String website, boolean audio) {
                                        result.success("audio " + link);
                                    }
                                }.run();

                            } else {
                                result.notImplemented();
                            }
                        }

                );
    }

    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }

        return batteryLevel;
    }
}
