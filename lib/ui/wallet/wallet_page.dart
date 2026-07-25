import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/base/util/current_student_session.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:flutter_bloc_template/data/repository/wallet/wallet_repository.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:gap/gap.dart';

/// شاشة "💳 المحفظة": الرصيد الحالي + آخر العمليات + دخول لشحن الرصيد أو
/// تفعيل كود.
@RoutePage()
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String? _studentId;

  @override
  void initState() {
    super.initState();
    CurrentStudentSession.getCurrentStudentId().then((id) {
      if (mounted) setState(() => _studentId = id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ownerRepo = OwnerContentRepository.instance;
    final walletRepo = WalletRepository.instance;

    if (_studentId == null) {
      return CommonScaffold(appBar: CommonAppBar(text: 'المحفظة'), body: const Center(child: Text('سجّل الدخول أولاً لعرض محفظتك')));
    }

    return CommonScaffold(
      appBar: CommonAppBar(text: 'المحفظة'),
      body: AnimatedBuilder(
        animation: Listenable.merge([ownerRepo, walletRepo]),
        builder: (context, _) {
          final student = ownerRepo.students.where((s) => s.id == _studentId);
          final balance = student.isNotEmpty ? student.first.walletBalance : 0.0;
          final transactions = walletRepo.transactionsOf(_studentId!);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.current.primary500, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الرصيد الحالي', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                      const Gap(6),
                      Text('${balance.toStringAsFixed(0)} د.ج', style: AppTextStyles.h1Bold.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
                const Gap(16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => AutoRouter.of(context).push(TopUpRequestRoute(studentId: _studentId!)),
                        icon: const Icon(Icons.add_card_outlined),
                        label: const Text('شحن الرصيد'),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => AutoRouter.of(context).push(RedeemCodeRoute(studentId: _studentId!)),
                        icon: const Icon(Icons.confirmation_number_outlined),
                        label: const Text('تفعيل كود'),
                      ),
                    ),
                  ],
                ),
                const Gap(24),
                Text('آخر العمليات', style: AppTextStyles.h3Bold),
                const Gap(12),
                if (transactions.isEmpty)
                  const Text('لا توجد عمليات بعد')
                else
                  ...transactions.map((t) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Icon(t.amount >= 0 ? Icons.arrow_downward : Icons.arrow_upward, color: t.amount >= 0 ? Colors.green : AppColors.current.error, size: 18),
                            const Gap(10),
                            Expanded(child: Text(t.note, style: AppTextStyles.bodySmallMedium)),
                            Text('${t.amount >= 0 ? '+' : ''}${t.amount.toStringAsFixed(0)} د.ج',
                                style: AppTextStyles.bodyMediumBold.copyWith(color: t.amount >= 0 ? Colors.green : AppColors.current.error)),
                          ],
                        ),
                      )),
              ],
            ),
          );
        },
      ),
    );
  }
}
