import 'package:flutter/foundation.dart';

/// المفضلة (راجع "❤️ المفضلة"): إضافة/إزالة/ترتيب دورات لكل طالب.
/// محلي في الذاكرة حاليًا (سيُربط بحساب الطالب على الخادم لاحقًا لمزامنته
/// بين الأجهزة، تمامًا مثل بقية المستودعات المحلية الموثّقة في `docs/`).
class FavoritesStore extends ChangeNotifier {
  FavoritesStore._internal();

  static final FavoritesStore instance = FavoritesStore._internal();

  final Map<String, List<String>> _favoriteCourseIdsByStudent = {};

  List<String> favoritesOf(String studentId) => List.unmodifiable(_favoriteCourseIdsByStudent[studentId] ?? const []);

  bool isFavorite(String studentId, String courseId) => (_favoriteCourseIdsByStudent[studentId] ?? const []).contains(courseId);

  void toggle(String studentId, String courseId) {
    final list = _favoriteCourseIdsByStudent.putIfAbsent(studentId, () => []);
    if (list.contains(courseId)) {
      list.remove(courseId);
    } else {
      list.add(courseId);
    }
    notifyListeners();
  }

  void reorder(String studentId, int oldIndex, int newIndex) {
    final list = _favoriteCourseIdsByStudent[studentId];
    if (list == null) return;
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    notifyListeners();
  }
}
