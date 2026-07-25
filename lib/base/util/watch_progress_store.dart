import 'package:shared_preferences/shared_preferences.dart';

/// يخزّن آخر نقطة توقف ونسبة الإنجاز لكل حصة محليًا على الجهاز، لتفعيل
/// "استكمال المشاهدة من آخر نقطة توقف" و"نسبة التقدّم لكل حصة" (القسم 5).
///
/// هذا تخزين محلي (Cache) للمرحلة الحالية بدون خادم. في المرحلة القادمة التي
/// تُبنى فيها API حقيقية، تُرفَع هذه القيم لحساب الطالب على الخادم أيضًا حتى
/// تُستكمَل المشاهدة من أي جهاز، لا من هذا الجهاز فقط.
abstract final class WatchProgressStore {
  WatchProgressStore._();

  static String _positionKey(String lessonId) => 'watch_position_$lessonId';
  static String _percentKey(String lessonId) => 'watch_percent_$lessonId';

  static Future<void> savePosition(String lessonId, Duration position, Duration total) async {
    if (lessonId.isEmpty || total.inMilliseconds == 0) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_positionKey(lessonId), position.inMilliseconds);
    final percent = (position.inMilliseconds / total.inMilliseconds * 100).clamp(0, 100);
    await prefs.setDouble(_percentKey(lessonId), percent);
  }

  static Future<Duration?> getLastPosition(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_positionKey(lessonId));
    return ms != null ? Duration(milliseconds: ms) : null;
  }

  /// نسبة إنجاز الحصة (0–100)، تُستخدم في "برنامج الدورة" (القسم 7) لتمييز
  /// الحصص المُنهاة بصريًا.
  static Future<double> getProgressPercent(String lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_percentKey(lessonId)) ?? 0;
  }
}
