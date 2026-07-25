/// نوع محتوى الحصة (راجع القسم 4: أنواع محتوى الحصص)
enum LessonType {
  video,
  pdfFile,
  image,
  textArticle,
  quiz,
  downloadableFile;

  static LessonType fromKey(String? key) {
    return LessonType.values.firstWhere(
      (e) => e.name == key,
      orElse: () => LessonType.video,
    );
  }
}
