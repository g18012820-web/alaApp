import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:gap/gap.dart';

/// إدارة الطلاب: إنشاء/تعديل/حذف/حظر/تعديل الرصيد (نسخة أولية محلية —
/// راجع `docs/owner-dashboard-screens.md` لبنود الحظر المتقدمة (IP/الجهاز)
/// التي تتطلب خادمًا حقيقيًا).
@RoutePage()
class OwnerStudentsPage extends StatelessWidget {
  const OwnerStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = OwnerContentRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'إدارة الطلاب'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.current.primary500,
        onPressed: () => _openForm(context, repo: repo),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          if (repo.students.isEmpty) {
            return const Center(child: Text('لا يوجد طلاب بعد'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: repo.students.length,
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (context, index) {
              final s = repo.students[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: s.isBlocked ? AppColors.current.error : AppColors.current.greyscale200),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.fullName, style: AppTextStyles.bodyLargeBold),
                              Text(s.email, style: AppTextStyles.bodySmallMedium),
                              Text(s.phoneNumber, style: AppTextStyles.bodySmallMedium),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${s.walletBalance.toStringAsFixed(0)} د.ج', style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.current.primary500)),
                            if (s.isBlocked) Text('محظور', style: AppTextStyles.bodySmallBold.copyWith(color: AppColors.current.error)),
                          ],
                        ),
                      ],
                    ),
                    const Gap(8),
                    Wrap(
                      spacing: 8,
                      children: [
                        OutlinedButton(onPressed: () => repo.adjustStudentBalance(s.id, 500), child: const Text('+500')),
                        OutlinedButton(onPressed: () => repo.adjustStudentBalance(s.id, -500), child: const Text('-500')),
                        OutlinedButton(
                          onPressed: () => repo.toggleStudentBlock(s.id),
                          child: Text(s.isBlocked ? 'فك الحظر' : 'حظر'),
                        ),
                        IconButton(icon: const Icon(Icons.edit_outlined, size: 20), onPressed: () => _openForm(context, repo: repo, existing: s)),
                        IconButton(
                          icon: Icon(Icons.delete_outline, size: 20, color: AppColors.current.error),
                          onPressed: () => repo.deleteStudent(s.id),
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

  void _openForm(BuildContext context, {required OwnerContentRepository repo, OwnerStudentRecord? existing}) {
    final nameController = TextEditingController(text: existing?.fullName ?? '');
    final emailController = TextEditingController(text: existing?.email ?? '');
    final phoneController = TextEditingController(text: existing?.phoneNumber ?? '');
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
              Text(existing == null ? 'طالب جديد' : 'تعديل الطالب', style: AppTextStyles.h5Bold),
              const Gap(16),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'الاسم الكامل', border: OutlineInputBorder())),
              const Gap(12),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'البريد الإلكتروني', border: OutlineInputBorder())),
              const Gap(12),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'رقم الهاتف', border: OutlineInputBorder())),
              const Gap(16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) return;
                    if (existing == null) {
                      repo.addStudent(fullName: nameController.text.trim(), email: emailController.text.trim(), phoneNumber: phoneController.text.trim());
                    } else {
                      repo.updateStudent(existing.id, fullName: nameController.text.trim(), email: emailController.text.trim(), phoneNumber: phoneController.text.trim());
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
