import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:gap/gap.dart';

/// تصفّح "📚 المواد" الحقيقية التي أنشأها المالك (بديل عن بيانات الـ API
/// الوهمي في الرئيسية). راجع `docs/full-integration.md`.
@RoutePage()
class StudentSubjectsPage extends StatelessWidget {
  const StudentSubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = OwnerContentRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'المواد'),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          if (repo.subjects.isEmpty) {
            return const Center(child: Text('لا توجد مواد منشورة بعد'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: repo.subjects.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              final subject = repo.subjects[index];
              final coursesCount = repo.coursesOf(subject.id).where((c) => c.status.name == 'saleActive').length;
              return InkWell(
                onTap: () => AutoRouter.of(context).push(StudentSubjectCoursesRoute(subjectId: subject.id, subjectName: subject.name)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(subject.name, style: AppTextStyles.bodyLargeBold),
                            if (subject.description.isNotEmpty) ...[
                              const Gap(4),
                              Text(subject.description, style: AppTextStyles.bodySmallMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                            const Gap(6),
                            Text('$coursesCount دورة متاحة', style: AppTextStyles.bodySmallMedium.copyWith(color: AppColors.current.primary500)),
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
