import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/wallet/wallet_repository.dart';
import 'package:gap/gap.dart';

/// شاشة "🎟️ الأكواد": إدخال كود ومعرفة حالته (نجاح/فشل) فورًا.
@RoutePage()
class RedeemCodePage extends StatefulWidget {
  final String studentId;

  const RedeemCodePage({super.key, required this.studentId});

  @override
  State<RedeemCodePage> createState() => _RedeemCodePageState();
}

class _RedeemCodePageState extends State<RedeemCodePage> {
  final _codeController = TextEditingController();
  String? _message;
  bool? _success;

  void _redeem() {
    final result = WalletRepository.instance.redeemCode(studentId: widget.studentId, rawCode: _codeController.text);
    setState(() {
      _message = result.message;
      _success = result.success;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(text: 'تفعيل كود'),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('أدخل الكود الذي حصلت عليه من المالك', style: AppTextStyles.bodyLargeMedium),
            const Gap(16),
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(hintText: 'XXXXX-XXXXX', border: OutlineInputBorder()),
            ),
            const Gap(16),
            if (_message != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (_success == true ? Colors.green : AppColors.current.error).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(_message!, style: TextStyle(color: _success == true ? Colors.green : AppColors.current.error)),
              ),
            const Gap(16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: _redeem,
                child: Text('تفعيل', style: AppTextStyles.bodyLargeBold.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
