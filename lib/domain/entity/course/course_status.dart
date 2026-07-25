/// حالات الدورة التي يتحكم بها المالك (راجع القسم 6: إدارة الدورات)
enum CourseStatus {
  saleActive, // البيع مفعل
  saleStopped, // البيع متوقف مؤقتًا
  registrationBlocked, // التسجيل مغلق
  hidden, // مخفية عن الطلاب
  archived, // مؤرشفة
  deleted; // محذوفة (حذف منطقي)

  static CourseStatus fromKey(String? key) {
    return CourseStatus.values.firstWhere(
      (e) => e.name == key,
      orElse: () => CourseStatus.saleActive,
    );
  }
}
