import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// إعدادات عامة تتحكم بالواجهة الحية (الوضع الليلي واللغة) — راجع "⚙️
/// الإعدادات". تُحفظ محليًا وتُقرأ عند إقلاع التطبيق عبر [loadSaved].
abstract final class AppSettingsController {
  AppSettingsController._();

  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static final ValueNotifier<Locale> locale = ValueNotifier(const Locale.fromSubtags(languageCode: 'ar'));

  static const _themeKey = 'app_theme_mode';
  static const _localeKey = 'app_locale';

  static Future<void> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme == 'dark') themeMode.value = ThemeMode.dark;
    final savedLocale = prefs.getString(_localeKey);
    if (savedLocale != null) locale.value = Locale.fromSubtags(languageCode: savedLocale);
  }

  static Future<void> toggleDarkMode(bool enabled) async {
    themeMode.value = enabled ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, enabled ? 'dark' : 'light');
  }

  static Future<void> setLanguage(String languageCode) async {
    locale.value = Locale.fromSubtags(languageCode: languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
  }
}
