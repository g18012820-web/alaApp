import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:flutter_bloc_template/domain/entity/course/course_entity.dart';
import 'package:flutter_bloc_template/domain/entity/course/course_status.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:gap/gap.dart';

/// شاشة إدارة دورات مادة معيّنة (القسم 3.2): إضافة دورة، تغيير حالتها
/// (بيع مفعّل/متوقف/مخفية...)، حذفها، أو الدخول إلى حصصها.
@RoutePage()
class OwnerCoursesPage extends StatelessWidget {
  final String subjectId;
  final String subjectName;

  const OwnerCoursesPage({super.key, required this.subjectId, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    final repo = OwnerContentRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'دورات: $subjectName'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.current.primary500,
        onPressed: () => _openForm(context, repo: repo),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          final courses = repo.coursesOf(subjectId);
          if (courses.isEmpty) {
            return const Center(child: Text('لا توجد دورات في هذه المادة بعد'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              final course = courses[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => AutoRouter.of(context).push(OwnerLessonsRoute(courseId: course.id, courseName: course.title)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(course.title, style: AppTextStyles.bodyLargeBold),
                                const Gap(4),
                                Text('${course.lessonsCount} حصة  ·  ${course.price} د.ج', style: AppTextStyles.bodySmallMedium),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_back_ios, size: 14),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<CourseStatus>(
                            value: course.status,
                            isDense: true,
                            decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                            items: CourseStatus.values
                                .map((s) => DropdownMenuItem(value: s, child: Text(_statusLabel(s), style: AppTextStyles.bodySmallMedium)))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) repo.updateCourseStatus(course.id, value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.quiz_outlined, size: 20, color: AppColors.current.primary500),
                          tooltip: 'الاختبارات',
                          onPressed: () => AutoRouter.of(context).push(OwnerQuizzesRoute(courseId: course.id, courseName: course.title)),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, size: 20, color: AppColors.current.error),
                          onPressed: () => _confirmDelete(context, repo: repo, course: course),
                        ),
                      ],
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

  String _statusLabel(CourseStatus status) {
    switch (status) {
      case CourseStatus.saleActive:
        return 'البيع مفعّل';
      case CourseStatus.saleStopped:
        return 'البيع متوقف';
      case CourseStatus.registrationBlocked:
        return 'التسجيل مغلق';
      case CourseStatus.hidden:
        return 'مخفية';
      case CourseStatus.archived:
        return 'مؤرشفة';
      case CourseStatus.deleted:
        return 'محذوفة';
    }
  }

  void _confirmDelete(BuildContext context, {required OwnerContentRepository repo, required CourseEntity course}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الدورة'),
        content: Text('سيتم حذف "${course.title}" وكل حصصها. هل أنت متأكد؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              repo.deleteCourse(course.id);
              Navigator.pop(context);
            },
            child: Text('حذف', style: TextStyle(color: AppColors.current.error)),
          ),
        ],
      ),
    );
  }

  void _openForm(BuildContext context, {required OwnerContentRepository repo}) {
    final titleController = TextEditingController();
    final aboutController = TextEditingController();
    final priceController = TextEditingController();
    final originalPriceController = TextEditingController();
    final mentorController = TextEditingController();
    bool certificate = false;

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
                    Text('دورة جديدة', style: AppTextStyles.h5Bold),
                    const Gap(16),
                    TextField(controller: titleController, decoration: const InputDecoration(labelText: 'عنوان الدورة', border: OutlineInputBorder())),
                    const Gap(12),
                    TextField(controller: aboutController, maxLines: 3, decoration: const InputDecoration(labelText: 'نبذة عن الدورة', border: OutlineInputBorder())),
                    const Gap(12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'السعر', border: OutlineInputBorder()),
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: TextField(
                            controller: originalPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'السعر الأصلي', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    TextField(controller: mentorController, decoration: const InputDecoration(labelText: 'اسم الأستاذ', border: OutlineInputBorder())),
                    const Gap(8),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: certificate,
                      onChanged: (value) => setState(() => certificate = value ?? false),
                      title: const Text('تمنح شهادة إتمام'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const Gap(8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: () {
                          if (titleController.text.trim().isEmpty) return;
                          repo.addCourse(
                            subjectId: subjectId,
                            title: titleController.text.trim(),
                            about: aboutController.text.trim(),
                            price: int.tryParse(priceController.text.trim()) ?? 0,
                            originalPrice: int.tryParse(originalPriceController.text.trim()) ?? 0,
                            certificate: certificate,
                            mentorName: mentorController.text.trim().isEmpty ? 'غير محدد' : mentorController.text.trim(),
                          );
                          Navigator.pop(context);
                        },
                        child: Text('حفظ', style: AppTextStyles.bodyLargeBold.copyWith(color: Colors.white)),
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
