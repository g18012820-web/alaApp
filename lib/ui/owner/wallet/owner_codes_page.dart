import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/wallet/wallet_repository.dart';
import 'package:gap/gap.dart';

/// إدارة الأكواد (راجع "🎟️ الأكواد" و"إدارة الأكواد"): توليد دفعات أكواد
/// رصيد/دورة، عرضها، نسخها، وحذفها.
///
/// ⚠️ تصدير Excel/CSV والطباعة (المذكورة في المواصفات) تحتاج مكتبات كتابة
/// ملفات إضافية؛ حاليًا تتوفر "نسخ الكل" للحافظة كبديل سريع — راجع
/// `docs/wallet-and-codes.md`.
@RoutePage()
class OwnerCodesPage extends StatelessWidget {
  const OwnerCodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = WalletRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'إدارة الأكواد'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.current.primary500,
        onPressed: () => _openGenerateForm(context, repo: repo),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          final codes = repo.codes;
          if (codes.isEmpty) {
            return const Center(child: Text('لا توجد أكواد بعد'));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
                child: Row(
                  children: [
                    Text('${codes.length} كود', style: AppTextStyles.bodyLargeBold),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        final text = codes.map((c) => c.code).join('\n');
                        Clipboard.setData(ClipboardData(text: text));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ كل الأكواد')));
                      },
                      icon: const Icon(Icons.copy_all_outlined, size: 18),
                      label: const Text('نسخ الكل'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingHorizontalLarge),
                  itemCount: codes.length,
                  separatorBuilder: (_, __) => const Gap(8),
                  itemBuilder: (context, index) {
                    final c = codes[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.code, style: AppTextStyles.bodyLargeBold.copyWith(letterSpacing: 1.2)),
                                Text('${_typeLabel(c.type)}  ·  ${c.value}', style: AppTextStyles.bodySmallMedium),
                              ],
                            ),
                          ),
                          if (c.isUsed)
                            const Text('مستخدم', style: TextStyle(color: Colors.grey, fontSize: 12))
                          else
                            IconButton(icon: Icon(Icons.delete_outline, size: 20, color: AppColors.current.error), onPressed: () => repo.deleteCode(c.code)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _typeLabel(CodeType type) {
    switch (type) {
      case CodeType.balance:
        return 'كود رصيد';
      case CodeType.course:
        return 'كود دورة';
      case CodeType.lesson:
        return 'كود حصة';
      case CodeType.accountActivation:
        return 'كود حساب';
    }
  }

  void _openGenerateForm(BuildContext context, {required WalletRepository repo}) {
    CodeType type = CodeType.balance;
    final valueController = TextEditingController();
    final countController = TextEditingController(text: '10');

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('توليد أكواد جديدة', style: AppTextStyles.h5Bold),
                  const Gap(16),
                  DropdownButtonFormField<CodeType>(
                    value: type,
                    decoration: const InputDecoration(labelText: 'نوع الكود', border: OutlineInputBorder()),
                    items: CodeType.values.map((t) => DropdownMenuItem(value: t, child: Text(_typeLabel(t)))).toList(),
                    onChanged: (value) => setState(() => type = value ?? CodeType.balance),
                  ),
                  const Gap(12),
                  TextField(
                    controller: valueController,
                    decoration: InputDecoration(
                      labelText: type == CodeType.balance ? 'قيمة الرصيد (د.ج)' : 'معرّف الدورة/الحصة',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const Gap(12),
                  TextField(
                    controller: countController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'عدد الأكواد', border: OutlineInputBorder()),
                  ),
                  const Gap(16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: () {
                        final count = int.tryParse(countController.text.trim()) ?? 0;
                        if (valueController.text.trim().isEmpty || count <= 0) return;
                        repo.generateCodes(type: type, value: valueController.text.trim(), count: count);
                        Navigator.pop(context);
                      },
                      child: Text('توليد', style: AppTextStyles.bodyLargeBold.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
