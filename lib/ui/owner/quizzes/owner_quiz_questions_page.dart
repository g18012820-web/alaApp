import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/quiz/quiz_repository.dart';
import 'package:gap/gap.dart';

/// إدارة أسئلة اختبار معيّن (بنك الأسئلة).
@RoutePage()
class OwnerQuizQuestionsPage extends StatelessWidget {
  final String courseId;
  final String quizId;
  final String quizTitle;

  const OwnerQuizQuestionsPage({super.key, required this.courseId, required this.quizId, required this.quizTitle});

  @override
  Widget build(BuildContext context) {
    final repo = QuizRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'أسئلة: $quizTitle'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.current.primary500,
        onPressed: () => _openForm(context, repo: repo),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          final quiz = repo.findQuiz(quizId);
          final questions = quiz?.questions ?? const [];
          if (questions.isEmpty) {
            return const Center(child: Text('لا توجد أسئلة بعد'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: questions.length,
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (context, index) {
              final q = questions[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${index + 1}. ${q.text}', style: AppTextStyles.bodyLargeBold),
                          const Gap(6),
                          ...List.generate(q.options.length, (i) {
                            final correct = q.correctOptionIndexes.contains(i);
                            return Text(
                              '${correct ? '✓' : '•'} ${q.options[i]}',
                              style: AppTextStyles.bodySmallMedium.copyWith(color: correct ? Colors.green : null),
                            );
                          }),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 20, color: AppColors.current.error),
                      onPressed: () => repo.deleteQuestion(courseId, quizId, q.id),
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
    final textController = TextEditingController();
    QuestionType type = QuestionType.multipleChoice;
    final optionControllers = [TextEditingController(), TextEditingController()];
    final correct = <int>{};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: Dimens.paddingHorizontalLarge,
                right: Dimens.paddingHorizontalLarge,
                top: Dimens.paddingVerticalLarge,
                bottom: MediaQuery.of(context).viewInsets.bottom + Dimens.paddingVerticalLarge,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('سؤال جديد', style: AppTextStyles.h5Bold),
                    const Gap(16),
                    TextField(controller: textController, decoration: const InputDecoration(labelText: 'نص السؤال', border: OutlineInputBorder())),
                    const Gap(12),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('اختيار متعدد'),
                            selected: type == QuestionType.multipleChoice,
                            onSelected: (_) => setState(() => type = QuestionType.multipleChoice),
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('صح / خطأ'),
                            selected: type == QuestionType.trueFalse,
                            onSelected: (_) => setState(() {
                              type = QuestionType.trueFalse;
                              correct.clear();
                            }),
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    if (type == QuestionType.trueFalse) ...[
                      RadioListTile<int>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('صحيح'),
                        value: 0,
                        groupValue: correct.isEmpty ? null : correct.first,
                        onChanged: (v) => setState(() {
                          correct
                            ..clear()
                            ..add(0);
                        }),
                      ),
                      RadioListTile<int>(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('خاطئ'),
                        value: 1,
                        groupValue: correct.isEmpty ? null : correct.first,
                        onChanged: (v) => setState(() {
                          correct
                            ..clear()
                            ..add(1);
                        }),
                      ),
                    ] else ...[
                      ...List.generate(optionControllers.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Checkbox(
                                value: correct.contains(i),
                                onChanged: (v) => setState(() {
                                  if (v == true) {
                                    correct.add(i);
                                  } else {
                                    correct.remove(i);
                                  }
                                }),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: optionControllers[i],
                                  decoration: InputDecoration(labelText: 'الخيار ${i + 1}', border: const OutlineInputBorder()),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      TextButton.icon(
                        onPressed: () => setState(() => optionControllers.add(TextEditingController())),
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة خيار'),
                      ),
                    ],
                    const Gap(12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: () {
                          if (textController.text.trim().isEmpty || correct.isEmpty) return;
                          final options = type == QuestionType.trueFalse ? ['صحيح', 'خاطئ'] : optionControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList();
                          repo.addQuestion(
                            courseId: courseId,
                            quizId: quizId,
                            text: textController.text.trim(),
                            type: type,
                            options: options,
                            correctOptionIndexes: correct.toList(),
                          );
                          Navigator.pop(context);
                        },
                        child: Text('حفظ السؤال', style: AppTextStyles.bodyLargeBold.copyWith(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
