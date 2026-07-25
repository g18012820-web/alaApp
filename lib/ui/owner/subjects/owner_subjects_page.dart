import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:flutter_bloc_template/domain/entity/course/category_entity.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:gap/gap.dart';

/// شاشة إدارة المواد الدراسية (القسم 3.1). إضافة/تعديل/حذف، ثم الانتقال منها
/// إلى دورات المادة (§3.2).
@RoutePage()
class OwnerSubjectsPage extends StatelessWidget {
  const OwnerSubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = OwnerContentRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'إدارة المواد'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.current.primary500,
        onPressed: () => _openForm(context, repo: repo),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          if (repo.subjects.isEmpty) {
            return const Center(child: Text('لا توجد مواد بعد، اضغط + للإضافة'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: repo.subjects.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              final subject = repo.subjects[index];
              final coursesCount = repo.coursesOf(subject.id).length;
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => AutoRouter.of(context).push(OwnerCoursesRoute(subjectId: subject.id, subjectName: subject.name)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(subject.name, style: AppTextStyles.bodyLargeBold),
                            if (subject.description.isNotEmpty) ...[
                              const Gap(4),
                              Text(subject.description, style: AppTextStyles.bodySmallMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                            const Gap(4),
                            Text('$coursesCount دورة', style: AppTextStyles.bodySmallRegular.copyWith(color: AppColors.current.primary500)),
                          ],
                        ),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () => _openForm(context, repo: repo, existing: subject)),
                    IconButton(
                      icon: Icon(Icons.delete_outline, size: 20, color: AppColors.current.error),
                      onPressed: () => _confirmDelete(context, repo: repo, subject: subject),
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

  void _confirmDelete(BuildContext context, {required OwnerContentRepository repo, required CategoryEntity subject}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المادة'),
        content: Text('سيتم حذف "${subject.name}" وكل دوراتها وحصصها. هل أنت متأكد؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              repo.deleteSubject(subject.id);
              Navigator.pop(context);
            },
            child: Text('حذف', style: TextStyle(color: AppColors.current.error)),
          ),
        ],
      ),
    );
  }

  void _openForm(BuildContext context, {required OwnerContentRepository repo, CategoryEntity? existing}) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final descController = TextEditingController(text: existing?.description ?? '');
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
              Text(existing == null ? 'مادة جديدة' : 'تعديل المادة', style: AppTextStyles.h5Bold),
              const Gap(16),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'اسم المادة', border: OutlineInputBorder())),
              const Gap(12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'الوصف (اختياري)', border: OutlineInputBorder()),
              ),
              const Gap(16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    if (existing == null) {
                      repo.addSubject(name: nameController.text.trim(), description: descController.text.trim());
                    } else {
                      repo.updateSubject(existing.id, name: nameController.text.trim(), description: descController.text.trim());
                    }
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
