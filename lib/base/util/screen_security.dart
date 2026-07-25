import 'dart:io';

import 'package:flutter/services.dart';

/// يمنع لقطة الشاشة/تسجيل الشاشة أثناء تشغيل الفيديو عبر FLAG_SECURE
/// (أندرويد فقط — راجع MainActivity.kt). على iOS لا توجد واجهة برمجية عامة
/// من آبل لمنع تسجيل الشاشة فعليًا؛ أقصى الممكن هو **اكتشاف** حدوث التسجيل
/// عبر `UIScreen.capturedDidChangeNotification` وإخفاء المحتوى عندها (غير مُنفَّذ
/// هنا بعد لأنه يتطلب كود Swift إضافي في AppDelegate).
abstract final class ScreenSecurity {
  ScreenSecurity._();

  static const _channel = MethodChannel('com.elearning/screen_security');

  static Future<void> enable() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('enableSecure');
    } catch (_) {
      // يُتجاهل بصمت إن تعذّر الاتصال بالقناة (مثلاً أثناء اختبارات الوحدة)
    }
  }

  static Future<void> disable() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('disableSecure');
    } catch (_) {}
  }
}
