import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:flutter_bloc_template/domain/entity/course/course_status.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:gap/gap.dart';

/// دورات مادة معيّنة من جهة الطالب. عند الضغط على دورة، يُفتَح
/// `CourseDetailRoute` **الأصلي من القالب** — والذي أصبح الآن (بعد الربط)
/// يعرض بيانات هذه الدورة الحقيقية وحصصها واختباراتها الفعلية.
@RoutePage()
class StudentSubjectCoursesPage extends StatelessWidget {
  final String subjectId;
  final String subjectName;

  const StudentSubjectCoursesPage({super.key, required this.subjectId, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    final repo = OwnerContentRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: subjectName),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          final courses = repo.coursesOf(subjectId).where((c) => c.status == CourseStatus.saleActive || c.status == CourseStatus.saleStopped).toList();
          if (courses.isEmpty) {
            return const Center(child: Text('لا توجد دورات متاحة في هذه المادة بعد'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              final course = courses[index];
              return InkWell(
                onTap: () => AutoRouter.of(context).push(CourseDetailRoute(id: course.id)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course.title, style: AppTextStyles.bodyLargeBold),
                            const Gap(4),
                            Text('${course.mentor.name}  ·  ${course.lessonsCount} حصة', style: AppTextStyles.bodySmallMedium),
                            const Gap(6),
                            Text(course.displayPrice(), style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.current.primary500)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_back_ios, size: 16),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
