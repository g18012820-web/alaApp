/// أدوار المستخدمين في المنصة: مالك واحد فقط، وعدد غير محدود من الطلاب.
/// (راجع القسم 2 من ملف المواصفات: نظام المستخدمين ثنائي الدور)
abstract final class UserRole {
  UserRole._();

  static const String owner = 'owner';
  static const String student = 'student';
}

extension UserRoleX on String {
  bool get isOwnerRole => this == UserRole.owner;
  bool get isStudentRole => this == UserRole.student;
}
