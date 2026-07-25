import 'package:flutter/foundation.dart';

enum QuestionType { multipleChoice, trueFalse }

/// سؤال ضمن اختبار (راجع "📝 الاختبارات"). نطاق هذه النسخة: اختيار متعدد
/// (بإجابة صحيحة واحدة أو أكثر) وصح/خطأ. الأنواع الأخرى (ترتيب، توصيل،
/// مقالي، سحب وإفلات) موثّقة كخطوة قادمة في `docs/quizzes.md` لأنها تحتاج
/// واجهات تفاعلية أعقد بكثير (سحب/توصيل عناصر) يصعب ضبطها يدويًا بثقة كاملة
/// في جلسة واحدة بدون مترجم Flutter لاختبارها.
class QuizQuestion {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final List<int> correctOptionIndexes;

  const QuizQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.correctOptionIndexes,
  });
}

class Quiz {
  final String id;
  final String courseId;
  final String title;
  final int timeLimitMinutes; // 0 = بلا حد زمني
  final int maxAttempts; // 0 = بلا حد
  final List<QuizQuestion> questions;

  const Quiz({
    required this.id,
    required this.courseId,
    required this.title,
    this.timeLimitMinutes = 0,
    this.maxAttempts = 0,
    this.questions = const [],
  });

  Quiz copyWith({String? title, int? timeLimitMinutes, int? maxAttempts, List<QuizQuestion>? questions}) {
    return Quiz(
      id: id,
      courseId: courseId,
      title: title ?? this.title,
      timeLimitMinutes: timeLimitMinutes ?? this.timeLimitMinutes,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      questions: questions ?? this.questions,
    );
  }
}

/// محاولة اختبار مكتملة، لعرضها في "مراجعة الإجابات" و"ترتيب الدرجات".
class QuizAttempt {
  final String id;
  final String quizId;
  final String studentId;
  final Map<String, List<int>> selectedByQuestionId;
  final double scorePercent;
  final DateTime submittedAt;

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.studentId,
    required this.selectedByQuestionId,
    required this.scorePercent,
    DateTime? submittedAt,
  }) : submittedAt = submittedAt ?? DateTime.now();

  bool get passed => scorePercent >= QuizRepository.passThresholdPercent;
}

class QuizRepository extends ChangeNotifier {
  QuizRepository._internal();

  static final QuizRepository instance = QuizRepository._internal();

  /// نسبة النجاح الثابتة لكل الاختبارات في هذه النسخة (قابلة للتحويل لاحقًا
  /// إلى إعداد لكل اختبار على حدة).
  static const double passThresholdPercent = 60;

  final Map<String, List<Quiz>> _quizzesByCourse = {};
  final List<QuizAttempt> _attempts = [];
  int _idCounter = 8000;

  String _newId() => (_idCounter++).toString();

  List<Quiz> quizzesOf(String courseId) => List.unmodifiable(_quizzesByCourse[courseId] ?? const []);

  Quiz? findQuiz(String quizId) {
    for (final list in _quizzesByCourse.values) {
      for (final quiz in list) {
        if (quiz.id == quizId) return quiz;
      }
    }
    return null;
  }

  void addQuiz({required String courseId, required String title, int timeLimitMinutes = 0, int maxAttempts = 0}) {
    final list = _quizzesByCourse.putIfAbsent(courseId, () => []);
    list.add(Quiz(id: _newId(), courseId: courseId, title: title, timeLimitMinutes: timeLimitMinutes, maxAttempts: maxAttempts));
    notifyListeners();
  }

  void deleteQuiz(String courseId, String quizId) {
    _quizzesByCourse[courseId]?.removeWhere((q) => q.id == quizId);
    _attempts.removeWhere((a) => a.quizId == quizId);
    notifyListeners();
  }

  void addQuestion({
    required String courseId,
    required String quizId,
    required String text,
    required QuestionType type,
    required List<String> options,
    required List<int> correctOptionIndexes,
  }) {
    final list = _quizzesByCourse[courseId];
    if (list == null) return;
    final index = list.indexWhere((q) => q.id == quizId);
    if (index == -1) return;
    final quiz = list[index];
    final question = QuizQuestion(id: _newId(), text: text, type: type, options: options, correctOptionIndexes: correctOptionIndexes);
    list[index] = quiz.copyWith(questions: [...quiz.questions, question]);
    notifyListeners();
  }

  void deleteQuestion(String courseId, String quizId, String questionId) {
    final list = _quizzesByCourse[courseId];
    if (list == null) return;
    final index = list.indexWhere((q) => q.id == quizId);
    if (index == -1) return;
    final quiz = list[index];
    list[index] = quiz.copyWith(questions: quiz.questions.where((q) => q.id != questionId).toList());
    notifyListeners();
  }

  // ── المحاولات ──────────────────────────────────────────
  int attemptsCountOf({required String quizId, required String studentId}) => _attempts.where((a) => a.quizId == quizId && a.studentId == studentId).length;

  List<QuizAttempt> attemptsHistory({required String quizId, required String studentId}) =>
      _attempts.where((a) => a.quizId == quizId && a.studentId == studentId).toList().reversed.toList();

  /// يصحح إجابات الطالب تلقائيًا ويُرجع المحاولة المُسجَّلة.
  QuizAttempt submitAttempt({required String quizId, required String studentId, required Map<String, List<int>> selectedByQuestionId}) {
    final quiz = findQuiz(quizId)!;
    var correctCount = 0;
    for (final question in quiz.questions) {
      final selected = (selectedByQuestionId[question.id] ?? const [])..sort();
      final correct = [...question.correctOptionIndexes]..sort();
      if (listEquals(selected, correct)) correctCount++;
    }
    final scorePercent = quiz.questions.isEmpty ? 0.0 : (correctCount / quiz.questions.length) * 100;
    final attempt = QuizAttempt(id: _newId(), quizId: quizId, studentId: studentId, selectedByQuestionId: selectedByQuestionId, scorePercent: scorePercent);
    _attempts.add(attempt);
    notifyListeners();
    return attempt;
  }

  /// متوسط درجات كل طلاب اختبار معيّن (لتقارير المالك).
  double averageScoreOf(String quizId) {
    final scores = _attempts.where((a) => a.quizId == quizId).map((a) => a.scorePercent).toList();
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }
}
