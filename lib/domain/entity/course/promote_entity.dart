class PromoteEntity {
  final String id;
  final String title;
  final String description;
  final String discount;
  final bool isActive;
  final DateTime expiryDate;

  PromoteEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.isActive,
    required this.expiryDate,
  });
}
