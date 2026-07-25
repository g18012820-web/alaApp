import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/base/util/current_student_session.dart';
import 'package:flutter_bloc_template/data/repository/quiz/quiz_repository.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:gap/gap.dart';

/// قائمة اختبارات دورة معيّنة من جهة الطالب، مع عدد المحاولات المتبقية
/// ونتيجة آخر محاولة.
@RoutePage()
class StudentQuizListPage extends StatefulWidget {
  final String courseId;
  final String courseName;

  const StudentQuizListPage({super.key, required this.courseId, required this.courseName});

  @override
  State<StudentQuizListPage> createState() => _StudentQuizListPageState();
}

class _StudentQuizListPageState extends State<StudentQuizListPage> {
  String? _studentId;

  @override
  void initState() {
    super.initState();
    CurrentStudentSession.getCurrentStudentId().then((id) {
      if (mounted) setState(() => _studentId = id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = QuizRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'اختبارات: ${widget.courseName}'),
      body: _studentId == null
          ? const Center(child: Text('سجّل الدخول أولاً'))
          : AnimatedBuilder(
              animation: repo,
              builder: (context, _) {
                final quizzes = repo.quizzesOf(widget.courseId);
                if (quizzes.isEmpty) {
                  return const Center(child: Text('لا توجد اختبارات لهذه الدورة بعد'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
                  itemCount: quizzes.length,
                  separatorBuilder: (_, __) => const Gap(10),
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    final attempts = repo.attemptsCountOf(quizId: quiz.id, studentId: _studentId!);
                    final history = repo.attemptsHistory(quizId: quiz.id, studentId: _studentId!);
                    final locked = quiz.maxAttempts > 0 && attempts >= quiz.maxAttempts;
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(quiz.title, style: AppTextStyles.bodyLargeBold),
                                const Gap(4),
                                Text(
                                  '${quiz.questions.length} سؤال  ·  ${quiz.timeLimitMinutes == 0 ? 'بلا وقت' : '${quiz.timeLimitMinutes} د'}'
                                  '${history.isNotEmpty ? '  ·  آخر نتيجة ${history.first.scorePercent.toStringAsFixed(0)}٪' : ''}',
                                  style: AppTextStyles.bodySmallMedium,
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: locked ? Colors.grey : AppColors.current.primary500),
                            onPressed: locked || quiz.questions.isEmpty
                                ? null
                                : () => AutoRouter.of(context).push(QuizTakingRoute(quizId: quiz.id, studentId: _studentId!)),
                            child: Text(locked ? 'انتهت المحاولات' : 'ابدأ', style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
