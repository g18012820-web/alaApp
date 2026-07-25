/// يمثّل حساب "الأستاذ" في المنصة (ملف تعريفي منسوب لمادة/دورات، وليس له تسجيل دخول منفصل)
class MentorEntity {
  final String id;
  final String name;
  final String title;
  final String avatarUrl;
  final String bio;
  final int coursesCount;

  MentorEntity({
    required this.id,
    required this.name,
    required this.title,
    required this.avatarUrl,
    this.bio = '',
    this.coursesCount = 0,
  });

  static MentorEntity defaultValue() => MentorEntity(id: '', name: '', title: '', avatarUrl: '');
}
