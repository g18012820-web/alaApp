import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/quiz/quiz_repository.dart';
import 'package:gap/gap.dart';

/// شاشة أداء الاختبار: مؤقّت (إن وُجد)، تنقّل بين الأسئلة، تصحيح تلقائي فوري
/// عند الإرسال، ومراجعة الإجابات (راجع "📝 الاختبارات").
@RoutePage()
class QuizTakingPage extends StatefulWidget {
  final String quizId;
  final String studentId;

  const QuizTakingPage({super.key, required this.quizId, required this.studentId});

  @override
  State<QuizTakingPage> createState() => _QuizTakingPageState();
}

class _QuizTakingPageState extends State<QuizTakingPage> {
  final Map<String, Set<int>> _selected = {};
  Timer? _timer;
  int _remainingSeconds = 0;
  QuizAttempt? _result;

  Quiz get _quiz => QuizRepository.instance.findQuiz(widget.quizId)!;

  @override
  void initState() {
    super.initState();
    final quiz = _quiz;
    if (quiz.timeLimitMinutes > 0) {
      _remainingSeconds = quiz.timeLimitMinutes * 60;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _remainingSeconds--);
        if (_remainingSeconds <= 0) {
          _timer?.cancel();
          _submit();
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _submit() {
    final answers = _selected.map((key, value) => MapEntry(key, value.toList()));
    final attempt = QuizRepository.instance.submitAttempt(quizId: widget.quizId, studentId: widget.studentId, selectedByQuestionId: answers);
    _timer?.cancel();
    setState(() => _result = attempt);
  }

  @override
  Widget build(BuildContext context) {
    final quiz = _quiz;
    final maxAttemptsReached = quiz.maxAttempts > 0 && QuizRepository.instance.attemptsCountOf(quizId: widget.quizId, studentId: widget.studentId) >= quiz.maxAttempts && _result == null;

    return CommonScaffold(
      appBar: CommonAppBar(text: quiz.title),
      body: maxAttemptsReached
          ? const Center(child: Text('استنفدت عدد المحاولات المسموح بها لهذا الاختبار'))
          : _result != null
              ? _buildResult(quiz, _result!)
              : _buildQuestions(quiz),
    );
  }

  Widget _buildQuestions(Quiz quiz) {
    return Column(
      children: [
        if (quiz.timeLimitMinutes > 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            color: _remainingSeconds < 30 ? AppColors.current.error.withOpacity(0.1) : AppColors.current.primary500.withOpacity(0.08),
            child: Text(
              'الوقت المتبقي: ${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLargeBold,
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: quiz.questions.length,
            itemBuilder: (context, index) {
              final q = quiz.questions[index];
              final selectedForQuestion = _selected.putIfAbsent(q.id, () => {});
              final multi = q.correctOptionIndexes.length > 1;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index + 1}. ${q.text}', style: AppTextStyles.bodyLargeBold),
                    const Gap(8),
                    ...List.generate(q.options.length, (i) {
                      final isSelected = selectedForQuestion.contains(i);
                      return InkWell(
                        onTap: () => setState(() {
                          if (multi) {
                            isSelected ? selectedForQuestion.remove(i) : selectedForQuestion.add(i);
                          } else {
                            selectedForQuestion
                              ..clear()
                              ..add(i);
                          }
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(isSelected ? Icons.check_circle : Icons.circle_outlined, size: 20, color: isSelected ? AppColors.current.primary500 : null),
                              const Gap(8),
                              Expanded(child: Text(q.options[i], style: AppTextStyles.bodyMedium)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
              onPressed: _submit,
              child: Text('إرسال الإجابات', style: AppTextStyles.bodyLargeBold.copyWith(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult(Quiz quiz, QuizAttempt attempt) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: (attempt.passed ? Colors.green : AppColors.current.error).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text('${attempt.scorePercent.toStringAsFixed(0)}٪', style: AppTextStyles.h1Bold),
                const Gap(6),
                Text(attempt.passed ? 'ناجح 🎉' : 'راسب', style: AppTextStyles.bodyLargeBold.copyWith(color: attempt.passed ? Colors.green : AppColors.current.error)),
              ],
            ),
          ),
          const Gap(20),
          Text('مراجعة الإجابات', style: AppTextStyles.h3Bold),
          const Gap(12),
          ...quiz.questions.map((q) {
            final selected = attempt.selectedByQuestionId[q.id] ?? const [];
            final correct = q.correctOptionIndexes;
            final isCorrect = (selected..sort()).toString() == (correct..sort()).toString();
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(border: Border.all(color: isCorrect ? Colors.green : AppColors.current.error), borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q.text, style: AppTextStyles.bodyLargeBold),
                  const Gap(6),
                  ...List.generate(q.options.length, (i) {
                    final wasSelected = selected.contains(i);
                    final isRight = correct.contains(i);
                    Color? color;
                    if (isRight) color = Colors.green;
                    if (wasSelected && !isRight) color = AppColors.current.error;
                    return Text('${wasSelected ? '● ' : '○ '}${q.options[i]}', style: AppTextStyles.bodySmallMedium.copyWith(color: color));
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
