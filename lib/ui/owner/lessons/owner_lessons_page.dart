import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:flutter_bloc_template/domain/entity/course/lesson_entity.dart';
import 'package:flutter_bloc_template/domain/entity/course/lesson_type.dart';
import 'package:gap/gap.dart';

/// شاشة إدارة حصص دورة معيّنة (القسم 3.3): إضافة حصة بأي نوع محتوى/مصدر
/// فيديو (يُستخدم رابطها لاحقًا مباشرة مع `UniversalVideoPlayer` من المرحلة 2)،
/// وحذفها.
@RoutePage()
class OwnerLessonsPage extends StatelessWidget {
  final String courseId;
  final String courseName;

  const OwnerLessonsPage({super.key, required this.courseId, required this.courseName});

  @override
  Widget build(BuildContext context) {
    final repo = OwnerContentRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'حصص: $courseName'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.current.primary500,
        onPressed: () => _openForm(context, repo: repo),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          final lessons = repo.lessonsOf(courseId);
          if (lessons.isEmpty) {
            return const Center(child: Text('لا توجد حصص في هذه الدورة بعد'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: lessons.length,
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.current.primary500.withOpacity(0.1),
                      child: Text('${index + 1}', style: AppTextStyles.bodySmallBold.copyWith(color: AppColors.current.primary500)),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(lesson.title, style: AppTextStyles.bodyLargeBold),
                          const Gap(2),
                          Text('${_typeLabel(lesson.type)}  ·  ${lesson.duration} د  ${lesson.isFree ? '· مجانية' : ''}',
                              style: AppTextStyles.bodySmallMedium),
                        ],
                      ),
                    ),
                    if (lesson.isLocked) const Icon(Icons.lock_outline, size: 18),
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 20, color: AppColors.current.error),
                      onPressed: () => repo.deleteLesson(courseId, lesson.id),
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

  String _typeLabel(LessonType type) {
    switch (type) {
      case LessonType.video:
        return 'فيديو';
      case LessonType.pdfFile:
        return 'ملف PDF';
      case LessonType.image:
        return 'صورة';
      case LessonType.textArticle:
        return 'مقال نصي';
      case LessonType.quiz:
        return 'اختبار';
      case LessonType.downloadableFile:
        return 'ملف قابل للتحميل';
    }
  }

  void _openForm(BuildContext context, {required OwnerContentRepository repo}) {
    final titleController = TextEditingController();
    final videoUrlController = TextEditingController();
    final durationController = TextEditingController();
    LessonType type = LessonType.video;
    bool isFree = false;
    bool isLocked = false;

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
                    Text('حصة جديدة', style: AppTextStyles.h5Bold),
                    const Gap(16),
                    TextField(controller: titleController, decoration: const InputDecoration(labelText: 'عنوان الحصة', border: OutlineInputBorder())),
                    const Gap(12),
                    DropdownButtonFormField<LessonType>(
                      value: type,
                      decoration: const InputDecoration(labelText: 'نوع المحتوى', border: OutlineInputBorder()),
                      items: LessonType.values.map((t) => DropdownMenuItem(value: t, child: Text(_typeLabel(t)))).toList(),
                      onChanged: (value) => setState(() => type = value ?? LessonType.video),
                    ),
                    const Gap(12),
                    TextField(
                      controller: videoUrlController,
                      decoration: const InputDecoration(
                        labelText: 'رابط الفيديو/الملف',
                        hintText: 'يُكتشف المصدر تلقائيًا (يوتيوب، رابط مباشر، HLS...)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Gap(12),
                    TextField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'المدة (بالدقائق)', border: OutlineInputBorder()),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isFree,
                      onChanged: (value) => setState(() => isFree = value ?? false),
                      title: const Text('حصة مجانية (معاينة)'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isLocked,
                      onChanged: (value) => setState(() => isLocked = value ?? false),
                      title: const Text('مقفلة حتى تفعيل الدورة'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const Gap(8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: () {
                          if (titleController.text.trim().isEmpty) return;
                          repo.addLesson(
                            courseId: courseId,
                            title: titleController.text.trim(),
                            type: type,
                            videoUrl: videoUrlController.text.trim(),
                            duration: int.tryParse(durationController.text.trim()) ?? 0,
                            isFree: isFree,
                            isLocked: isLocked,
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
