class LessonResponseDto {
  final String id;
  final String title;
  final int duration;
  final String videoUrl;
  final bool isFree;
  final String? type;
  final int? order;
  final bool? isLocked;
  final String? scheduledAt;

  LessonResponseDto({
    required this.id,
    required this.title,
    required this.duration,
    required this.videoUrl,
    required this.isFree,
    this.type,
    this.order,
    this.isLocked,
    this.scheduledAt,
  });

  factory LessonResponseDto.fromJson(Map<String, dynamic> json) {
    return LessonResponseDto(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      videoUrl: json['videoUrl'],
      isFree: json['isFree'],
      type: json['type'] as String?,
      order: json['order'] as int?,
      isLocked: json['isLocked'] as bool?,
      scheduledAt: json['scheduledAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'videoUrl': videoUrl,
      'isFree': isFree,
      'type': type,
      'order': order,
      'isLocked': isLocked,
      'scheduledAt': scheduledAt,
    };
  }
}
