package com.example.flutter_bloc_template

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/// قناة أصلية (Native MethodChannel) تمنع التقاط الشاشة/التسجيل أثناء تشغيل
/// الفيديو (FLAG_SECURE)، تُفعَّل وتُعطَّل من Flutter فقط في شاشة تشغيل الحصة
/// حتى لا تُعطَّل ميزات لقطة الشاشة في بقية شاشات التطبيق.
/// (راجع القسم 5 من ملف المواصفات: "منع التحميل ومنع تسجيل الشاشة")
class MainActivity : FlutterActivity() {
    private val channel = "com.elearning/screen_security"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableSecure" -> {
                    window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(true)
                }
                "disableSecure" -> {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
