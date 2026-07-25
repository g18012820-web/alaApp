import 'package:shared_preferences/shared_preferences.dart';

/// بيانات دخول المالك محليًا. المالك واحد فقط في كامل النظام (راجع القسم 2).
///
/// ⚠️ هذا حل مؤقت للمرحلة الحالية (لا يوجد خادم بعد): بيانات الدخول مخزّنة على
/// الجهاز نفسه عبر `shared_preferences`، وليست مشفّرة بتشفير قوي. عند بناء
/// الخادم الفعلي (راجع `docs/phase-1-design.md`) يجب زرع حساب المالك على
/// الخادم (bcrypt/argon2) والتوقف عن الاعتماد على هذا التخزين المحلي فورًا،
/// لأن أي شخص يملك الجهاز فعليًا (أو نسخة احتياطية منه) قد يصل إليها.
abstract final class OwnerAuthStore {
  OwnerAuthStore._();

  static const _emailKey = 'owner_email';
  static const _passwordKey = 'owner_password';

  // بيانات افتراضية مبدئية — يُنصح بتغييرها فورًا من "لوحة المالك → الإعدادات → بيانات الدخول"
  static const defaultEmail = 'owner@platform.com';
  static const defaultPassword = 'Owner@12345';

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? defaultEmail;
  }

  static Future<String> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey) ?? defaultPassword;
  }

  static Future<void> updateCredentials({required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
  }

  /// يتحقق مما إذا كانت بيانات الدخول المُدخلة تطابق بيانات المالك المحفوظة.
  static Future<bool> matches({required String email, required String password}) async {
    final savedEmail = await getEmail();
    final savedPassword = await getPassword();
    return email.trim().toLowerCase() == savedEmail.trim().toLowerCase() && password == savedPassword;
  }
}
