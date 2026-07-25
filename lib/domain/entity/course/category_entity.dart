/// يمثّل "المادة الدراسية" (Subject) في المنصة (راجع القسم 3)
class CategoryEntity {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String colorHex;
  final int coursesCount;

  CategoryEntity({
    required this.id,
    required this.name,
    this.description = '',
    this.imageUrl = '',
    this.colorHex = '',
    this.coursesCount = 0,
  });
}
