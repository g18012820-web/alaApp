import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/quiz/quiz_repository.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:gap/gap.dart';

/// إدارة اختبارات دورة معيّنة (راجع "إدارة الاختبارات" في لوحة المالك).
@RoutePage()
class OwnerQuizzesPage extends StatelessWidget {
  final String courseId;
  final String courseName;

  const OwnerQuizzesPage({super.key, required this.courseId, required this.courseName});

  @override
  Widget build(BuildContext context) {
    final repo = QuizRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'اختبارات: $courseName'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.current.primary500,
        onPressed: () => _openForm(context, repo: repo),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          final quizzes = repo.quizzesOf(courseId);
          if (quizzes.isEmpty) {
            return const Center(child: Text('لا توجد اختبارات بعد'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: quizzes.length,
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => AutoRouter.of(context).push(OwnerQuizQuestionsRoute(courseId: courseId, quizId: quiz.id, quizTitle: quiz.title)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(quiz.title, style: AppTextStyles.bodyLargeBold),
                            const Gap(4),
                            Text(
                              '${quiz.questions.length} سؤال  ·  ${quiz.timeLimitMinutes == 0 ? 'بلا وقت' : '${quiz.timeLimitMinutes} د'}  ·  متوسط ${repo.averageScoreOf(quiz.id).toStringAsFixed(0)}٪',
                              style: AppTextStyles.bodySmallMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 20, color: AppColors.current.error),
                      onPressed: () => repo.deleteQuiz(courseId, quiz.id),
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

  void _openForm(BuildContext context, {required QuizRepository repo}) {
    final titleController = TextEditingController();
    final timeController = TextEditingController(text: '0');
    final attemptsController = TextEditingController(text: '0');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: Dimens.paddingHorizontalLarge,
            right: Dimens.paddingHorizontalLarge,
            top: Dimens.paddingVerticalLarge,
            bottom: MediaQuery.of(context).viewInsets.bottom + Dimens.paddingVerticalLarge,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('اختبار جديد', style: AppTextStyles.h5Bold),
              const Gap(16),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'عنوان الاختبار', border: OutlineInputBorder())),
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'الوقت (دقيقة، 0=بلا حد)', border: OutlineInputBorder()),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: TextField(
                      controller: attemptsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'المحاولات (0=بلا حد)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) return;
                    repo.addQuiz(
                      courseId: courseId,
                      title: titleController.text.trim(),
                      timeLimitMinutes: int.tryParse(timeController.text.trim()) ?? 0,
                      maxAttempts: int.tryParse(attemptsController.text.trim()) ?? 0,
                    );
                    Navigator.pop(context);
                  },
                  child: Text('حفظ', style: AppTextStyles.bodyLargeBold.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
