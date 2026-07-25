import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:gap/gap.dart';

/// إدارة الأساتذة: مجرد ملفات تعريفية (بلا حساب دخول)، تُربط لاحقًا بالدورات
/// عند إضافة دورة.
@RoutePage()
class OwnerTeachersPage extends StatelessWidget {
  const OwnerTeachersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = OwnerContentRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'إدارة الأساتذة'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.current.primary500,
        onPressed: () => _openForm(context, repo: repo),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          if (repo.teachers.isEmpty) {
            return const Center(child: Text('لا يوجد أساتذة بعد'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: repo.teachers.length,
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (context, index) {
              final t = repo.teachers[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: AppColors.current.primary500.withOpacity(0.1), child: Text(t.name.isNotEmpty ? t.name.substring(0, 1) : '?')),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.name, style: AppTextStyles.bodyLargeBold),
                          if (t.bio.isNotEmpty) Text(t.bio, style: AppTextStyles.bodySmallMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    IconButton(icon: Icon(Icons.delete_outline, size: 20, color: AppColors.current.error), onPressed: () => repo.deleteTeacher(t.id)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openForm(BuildContext context, {required OwnerContentRepository repo}) {
    final nameController = TextEditingController();
    final bioController = TextEditingController();
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
              Text('أستاذ جديد', style: AppTextStyles.h5Bold),
              const Gap(16),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'الاسم', border: OutlineInputBorder())),
              const Gap(12),
              TextField(controller: bioController, maxLines: 2, decoration: const InputDecoration(labelText: 'نبذة/تخصص', border: OutlineInputBorder())),
              const Gap(16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    repo.addTeacher(name: nameController.text.trim(), bio: bioController.text.trim());
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
