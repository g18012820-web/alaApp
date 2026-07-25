import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_template/domain/entity/course/category_entity.dart';
import 'package:flutter_bloc_template/domain/entity/course/course_entity.dart';
import 'package:flutter_bloc_template/domain/entity/course/course_status.dart';
import 'package:flutter_bloc_template/domain/entity/course/lesson_entity.dart';
import 'package:flutter_bloc_template/domain/entity/course/lesson_type.dart';
import 'package:flutter_bloc_template/domain/entity/course/mentor_entity.dart';

/// بيانات طالب مبسّطة لإدارة الطلاب من لوحة المالك (القسم "إدارة الطلاب").
class OwnerStudentRecord {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final double walletBalance;
  final bool isBlocked;

  const OwnerStudentRecord({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.walletBalance = 0,
    this.isBlocked = false,
  });

  OwnerStudentRecord copyWith({String? fullName, String? email, String? phoneNumber, double? walletBalance, bool? isBlocked}) {
    return OwnerStudentRecord(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      walletBalance: walletBalance ?? this.walletBalance,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}

/// سجل أستاذ مستقل (ملف تعريفي فقط، بلا حساب دخول — راجع القسم "إدارة الأساتذة").
class OwnerTeacherRecord {
  final String id;
  final String name;
  final String bio;

  const OwnerTeacherRecord({required this.id, required this.name, this.bio = ''});
}

/// مستودع محتوى لوحة المالك: يخزّن المواد/الدورات/الحصص **محليًا في الذاكرة**
/// (لا يوجد خادم حقيقي بعد). كل شاشات لوحة المالك تقرأ/تكتب من هنا فقط،
/// لذا عند بناء الـ API الحقيقية لاحقًا يكفي استبدال تطبيق هذه الفئة بواحد
/// يتحدث مع الخادم (Retrofit) دون تغيير أي شاشة.
///
/// `ChangeNotifier` بسيط بدل Bloc الكامل لأن هذا مستودع مؤقت بلا شبكة ولا
/// حالات تحميل/خطأ حقيقية بعد؛ سيُستبدل ببنية bloc/use-case الرسمية للمشروع
/// عند ربطه بخادم فعلي (متوافق مع نمط بقية المشروع: data → domain → ui).
class OwnerContentRepository extends ChangeNotifier {
  OwnerContentRepository._internal() {
    _seedDemoData();
  }

  static final OwnerContentRepository instance = OwnerContentRepository._internal();

  final List<CategoryEntity> _subjects = [];
  final List<CourseEntity> _courses = [];
  final Map<String, List<LessonEntity>> _lessonsByCourse = {};
  final List<OwnerStudentRecord> _students = [];
  final List<OwnerTeacherRecord> _teachers = [];
  final Map<String, List<String>> _enrollments = {};
  int _idCounter = 1000;

  String _newId() => (_idCounter++).toString();

  // ── قراءة ──────────────────────────────────────────────
  List<CategoryEntity> get subjects => List.unmodifiable(_subjects);

  List<CourseEntity> coursesOf(String subjectId) => _courses.where((c) => c.subjectId == subjectId).toList();

  List<LessonEntity> lessonsOf(String courseId) => List.unmodifiable(_lessonsByCourse[courseId] ?? const []);

  // ── المواد ─────────────────────────────────────────────
  void addSubject({required String name, String description = '', String colorHex = ''}) {
    _subjects.add(CategoryEntity(id: _newId(), name: name, description: description, colorHex: colorHex));
    notifyListeners();
  }

  void updateSubject(String id, {required String name, String description = '', String colorHex = ''}) {
    final index = _subjects.indexWhere((s) => s.id == id);
    if (index == -1) return;
    _subjects[index] = CategoryEntity(id: id, name: name, description: description, colorHex: colorHex, coursesCount: _subjects[index].coursesCount);
    notifyListeners();
  }

  void deleteSubject(String id) {
    _subjects.removeWhere((s) => s.id == id);
    final courseIds = _courses.where((c) => c.subjectId == id).map((c) => c.id).toList();
    _courses.removeWhere((c) => c.subjectId == id);
    for (final cid in courseIds) {
      _lessonsByCourse.remove(cid);
    }
    notifyListeners();
  }

  // ── الدورات ────────────────────────────────────────────
  void addCourse({
    required String subjectId,
    required String title,
    required String about,
    required int price,
    required int originalPrice,
    required bool certificate,
    required String mentorName,
    CourseStatus status = CourseStatus.saleActive,
  }) {
    _courses.add(CourseEntity(
      id: _newId(),
      title: title,
      category: subjectId,
      subjectId: subjectId,
      image: '',
      coverImage: '',
      price: price,
      originalPrice: originalPrice,
      rating: 0,
      reviewsCount: 0,
      students: 0,
      duration: 0,
      certificate: certificate,
      mentor: MentorEntity(id: _newId(), name: mentorName, title: '', avatarUrl: ''),
      tools: const [],
      about: about,
      isFavourite: false,
      status: status,
    ));
    notifyListeners();
  }

  void updateCourseStatus(String courseId, CourseStatus status) {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index == -1) return;
    final c = _courses[index];
    _courses[index] = CourseEntity(
      id: c.id,
      title: c.title,
      category: c.category,
      subjectId: c.subjectId,
      image: c.image,
      coverImage: c.coverImage,
      price: c.price,
      originalPrice: c.originalPrice,
      rating: c.rating,
      reviewsCount: c.reviewsCount,
      students: c.students,
      duration: c.duration,
      certificate: c.certificate,
      mentor: c.mentor,
      tools: c.tools,
      about: c.about,
      isFavourite: c.isFavourite,
      status: status,
      lessonsCount: c.lessonsCount,
    );
    notifyListeners();
  }

  void deleteCourse(String courseId) {
    _courses.removeWhere((c) => c.id == courseId);
    _lessonsByCourse.remove(courseId);
    notifyListeners();
  }

  // ── الحصص ──────────────────────────────────────────────
  void addLesson({
    required String courseId,
    required String title,
    required LessonType type,
    required String videoUrl,
    required int duration,
    bool isFree = false,
    bool isLocked = false,
  }) {
    final list = _lessonsByCourse.putIfAbsent(courseId, () => []);
    list.add(LessonEntity(
      id: _newId(),
      title: title,
      duration: duration,
      videoUrl: videoUrl,
      isFree: isFree,
      type: type,
      order: list.length,
      isLocked: isLocked,
    ));
    _syncLessonsCount(courseId);
    notifyListeners();
  }

  void deleteLesson(String courseId, String lessonId) {
    _lessonsByCourse[courseId]?.removeWhere((l) => l.id == lessonId);
    _syncLessonsCount(courseId);
    notifyListeners();
  }

  void _syncLessonsCount(String courseId) {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index == -1) return;
    final c = _courses[index];
    _courses[index] = CourseEntity(
      id: c.id,
      title: c.title,
      category: c.category,
      subjectId: c.subjectId,
      image: c.image,
      coverImage: c.coverImage,
      price: c.price,
      originalPrice: c.originalPrice,
      rating: c.rating,
      reviewsCount: c.reviewsCount,
      students: c.students,
      duration: c.duration,
      certificate: c.certificate,
      mentor: c.mentor,
      tools: c.tools,
      about: c.about,
      isFavourite: c.isFavourite,
      status: c.status,
      lessonsCount: _lessonsByCourse[courseId]?.length ?? 0,
    );
  }

  // ── الطلاب ─────────────────────────────────────────────
  List<OwnerStudentRecord> get students => List.unmodifiable(_students);

  String addStudent({required String fullName, required String email, required String phoneNumber}) {
    final id = _newId();
    _students.add(OwnerStudentRecord(id: id, fullName: fullName, email: email, phoneNumber: phoneNumber));
    notifyListeners();
    return id;
  }

  /// يبحث عن طالب موجود بهذا البريد، أو ينشئ سجلًا جديدًا له إن لم يوجد.
  /// يُستخدم من شاشة الدخول لأنه لا يوجد خادم مصادقة حقيقي بعد يمنع دخول
  /// بريد غير مسجّل أصلًا — راجع `docs/wallet-and-codes.md`.
  String findOrCreateByEmail({required String email, String fallbackName = 'طالب'}) {
    final existing = _students.where((s) => s.email.toLowerCase() == email.toLowerCase());
    if (existing.isNotEmpty) return existing.first.id;
    return addStudent(fullName: fallbackName, email: email, phoneNumber: '');
  }
  void updateStudent(String id, {required String fullName, required String email, required String phoneNumber}) {
    final index = _students.indexWhere((s) => s.id == id);
    notifyListeners();
  }

  void adjustStudentBalance(String id, double delta) {
    final index = _students.indexWhere((s) => s.id == id);
    if (index == -1) return;
    final current = _students[index];
    _students[index] = current.copyWith(walletBalance: (current.walletBalance + delta).clamp(0, double.infinity));
    notifyListeners();
  }

  void toggleStudentBlock(String id) {
    final index = _students.indexWhere((s) => s.id == id);
    if (index == -1) return;
    _students[index] = _students[index].copyWith(isBlocked: !_students[index].isBlocked);
    notifyListeners();
  }

  void deleteStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // ── الأساتذة ───────────────────────────────────────────
  List<OwnerTeacherRecord> get teachers => List.unmodifiable(_teachers);

  void addTeacher({required String name, String bio = ''}) {
    _teachers.add(OwnerTeacherRecord(id: _newId(), name: name, bio: bio));
    notifyListeners();
  }

  void deleteTeacher(String id) {
    _teachers.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // ── التسجيل في الدورات (Enrollment) ─────────────────────
  bool isEnrolled(String studentId, String courseId) => (_enrollments[studentId] ?? const []).contains(courseId);

  List<CourseEntity> enrolledCoursesOf(String studentId) {
    final ids = _enrollments[studentId] ?? const [];
    final all = subjects.expand((s) => coursesOf(s.id));
    return all.where((c) => ids.contains(c.id)).toList();
  }

  void enroll(String studentId, String courseId) {
    final list = _enrollments.putIfAbsent(studentId, () => []);
    if (!list.contains(courseId)) list.add(courseId);
    notifyListeners();
  }

  void _seedDemoData() {
    final mathId = _newId();
    _subjects.add(CategoryEntity(id: mathId, name: 'الرياضيات', description: 'مادة الرياضيات لكل المستويات', colorHex: '#4C6FFF'));
    addCourse(subjectId: mathId, title: 'أساسيات الجبر', about: 'مقدمة شاملة في الجبر', price: 2000, originalPrice: 3000, certificate: true, mentorName: 'أ. محمد قاسمي');
  }
}
