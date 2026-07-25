import 'package:shared_preferences/shared_preferences.dart';

/// إعدادات عامة للمنصة يتحكم بها المالك (راجع "🔐 تفعيل الحساب" في مواصفات
/// تطبيق الطالب). حاليًا تحتوي فقط على مفتاح تفعيل الحساب برمز، وستتوسع في
/// المراحل القادمة (إعدادات الدفع، الجلسات...).
abstract final class PlatformSettingsStore {
  PlatformSettingsStore._();

  static const _activationRequiredKey = 'platform_activation_required';

  /// عند التفعيل: الحسابات الجديدة (وليس القديمة) يجب أن تُدخل رمز تفعيل قبل
  /// استخدام التطبيق. القيمة الافتراضية `false` حتى لا يُحجب أي مستخدم تجريبي
  /// عن اختبار التطبيق قبل أن يُهيّئ المالك آلية إرسال الرمز الحقيقية (SMS/بريد)
  /// عبر الخادم.
  static Future<bool> isActivationRequired() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_activationRequiredKey) ?? false;
  }

  static Future<void> setActivationRequired(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_activationRequiredKey, value);
  }
}
