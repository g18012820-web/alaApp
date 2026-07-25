import 'package:flutter_bloc_template/domain/entity/course/lesson_type.dart';

class LessonEntity {
  final String id;
  final String title;
  final int duration;
  final String videoUrl;
  final bool isFree;

  /// نوع محتوى الحصة: فيديو، ملف PDF، اختبار...
  final LessonType type;

  /// ترتيب الحصة داخل الدورة
  final int order;

  /// هل الحصة مقفلة على الطالب حتى يفعّل الدورة (كود/دفع)
  final bool isLocked;

  /// موعد بث الحصة المجدولة، إن وُجد (للحصص المباشرة/المجدولة)
  final DateTime? scheduledAt;

  LessonEntity({
    required this.id,
    required this.title,
    required this.duration,
    required this.videoUrl,
    required this.isFree,
    this.type = LessonType.video,
    this.order = 0,
    this.isLocked = false,
    this.scheduledAt,
  });

}
