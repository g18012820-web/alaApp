import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/wallet/wallet_repository.dart';
import 'package:gap/gap.dart';

/// إدارة طلبات الشحن (راجع "إدارة الشحن" في مواصفات لوحة المالك): مراجعة
/// الصورة، قبول، رفض مع ملاحظة.
@RoutePage()
class OwnerChargingPage extends StatelessWidget {
  const OwnerChargingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = WalletRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'إدارة الشحن'),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          final requests = repo.topUpRequests;
          if (requests.isEmpty) {
            return const Center(child: Text('لا توجد طلبات شحن'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: requests.length,
            separatorBuilder: (_, __) => const Gap(12),
            itemBuilder: (context, index) {
              final r = requests[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.studentName, style: AppTextStyles.bodyLargeBold),
                              Text('${r.amount.toStringAsFixed(0)} د.ج  ·  ${r.method == TopUpMethod.ccp ? 'CCP' : 'بريدي موب'}', style: AppTextStyles.bodySmallMedium),
                            ],
                          ),
                        ),
                        _statusChip(r.status),
                      ],
                    ),
                    if (r.receiptImagePath != null) ...[
                      const Gap(10),
                      GestureDetector(
                        onTap: () => _showFullImage(context, r.receiptImagePath!),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(File(r.receiptImagePath!), height: 140, width: double.infinity, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                    if (r.status == TopUpStatus.pending) ...[
                      const Gap(10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => repo.rejectTopUp(r.id, note: 'مرفوض من المالك'),
                              child: Text('رفض', style: TextStyle(color: AppColors.current.error)),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500),
                              onPressed: () => repo.approveTopUp(r.id),
                              child: const Text('قبول', style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _statusChip(TopUpStatus status) {
    final (label, color) = switch (status) {
      TopUpStatus.pending => ('قيد الانتظار', Colors.orange),
      TopUpStatus.approved => ('مقبول', Colors.green),
      TopUpStatus.rejected => ('مرفوض', Colors.red),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(100)),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  void _showFullImage(BuildContext context, String path) {
    showDialog(context: context, builder: (context) => Dialog(child: Image.file(File(path))));
  }
}
