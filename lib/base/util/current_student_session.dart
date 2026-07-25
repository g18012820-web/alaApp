import 'package:shared_preferences/shared_preferences.dart';

/// يتتبّع الطالب "المسجّل دخوله حاليًا" محليًا على الجهاز. لا يوجد بعد JWT ولا
/// جلسة خادم حقيقية (راجع القسم "🔒 الأمان" في المواصفات لبنود الجلسات
/// المتقدمة التي تحتاج خادمًا)، لذلك هذا مجرد "من أنا" محلي تعتمد عليه شاشات
/// المحفظة والملف الشخصي لمعرفة صاحب البيانات المعروضة.
abstract final class CurrentStudentSession {
  CurrentStudentSession._();

  static const _idKey = 'current_student_id';

  static Future<void> setCurrentStudentId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_idKey, id);
  }

  static Future<String?> getCurrentStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idKey);
  }
}
