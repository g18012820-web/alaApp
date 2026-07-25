class ReviewEntity {
  final String id;
  final String courseId;
  final String userId;
  final double rating;
  final String comment;
  final String createdAt;

  ReviewEntity({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
