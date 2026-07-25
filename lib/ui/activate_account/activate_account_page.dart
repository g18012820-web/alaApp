import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_button.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/base/shared_view/common_text_field.dart';
import 'package:flutter_bloc_template/base/util/activation_code_store.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:gap/gap.dart';

/// شاشة إدخال رمز تفعيل الحساب (راجع "🔐 تفعيل الحساب"): تظهر فقط إن فعّلها
/// المالك من الإعدادات، ولا يمكن تجاوزها لاستخدام التطبيق قبل رمز صحيح.
@RoutePage()
class ActivateAccountPage extends StatefulWidget {
  final String email;

  const ActivateAccountPage({super.key, required this.email});

  @override
  State<ActivateAccountPage> createState() => _ActivateAccountPageState();
}

class _ActivateAccountPageState extends State<ActivateAccountPage> {
  final _codeController = TextEditingController();
  String? _error;

  void _verify() {
    final code = _codeController.text.trim();
    if (ActivationCodeStore.verify(widget.email, code)) {
      AutoRouter.of(context).replaceAll([const MainRoute()]);
    } else {
      setState(() => _error = 'الرمز غير صحيح، حاول مجددًا');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(text: 'تفعيل الحساب'),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Text('أدخل رمز التفعيل المرسل إلى', style: AppTextStyles.bodyLargeMedium),
            Text(widget.email, style: AppTextStyles.bodyLargeBold.copyWith(color: AppColors.current.primary500)),
            const Gap(24),
            CommonTextField(
              controller: _codeController,
              hintText: '000000',
              keyboardType: TextInputType.number,
              maxLength: 6,
              errorText: _error,
              onChanged: (val) => setState(() => _error = null),
            ),
            const Gap(20),
            CommonButton(enable: true, onPressed: _verify, title: 'تفعيل الحساب', fullWidth: true),
          ],
        ),
      ),
    );
  }
}
