import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/base/util/platform_settings_store.dart';
import 'package:gap/gap.dart';

/// إعدادات التسجيل: تفعيل/إيقاف اشتراط رمز التفعيل بعد إنشاء الحساب (راجع
/// "🔐 تفعيل الحساب" — الحسابات القديمة لا تتأثر بالتغيير).
@RoutePage()
class OwnerRegistrationSettingsPage extends StatefulWidget {
  const OwnerRegistrationSettingsPage({super.key});

  @override
  State<OwnerRegistrationSettingsPage> createState() => _OwnerRegistrationSettingsPageState();
}

class _OwnerRegistrationSettingsPageState extends State<OwnerRegistrationSettingsPage> {
  bool _activationRequired = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    PlatformSettingsStore.isActivationRequired().then((value) {
      if (!mounted) return;
      setState(() {
        _activationRequired = value;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(text: 'إعدادات التسجيل'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _activationRequired,
                    title: Text('اشتراط تفعيل الحساب برمز', style: AppTextStyles.bodyLargeBold),
                    subtitle: const Text('عند التفعيل، لن يستطيع الطالب استخدام التطبيق بعد التسجيل قبل إدخال رمز صحيح.'),
                    onChanged: (value) async {
                      await PlatformSettingsStore.setActivationRequired(value);
                      setState(() => _activationRequired = value);
                    },
                  ),
                  const Gap(12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.amber.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      '⚠️ الرمز حاليًا يُعرض مباشرة للطالب على الشاشة كعرض تجريبي، لأنه لا يوجد خادم SMS/بريد حقيقي بعد. لا تُفعّل هذا الخيار في بيئة إنتاج حقيقية قبل ربط خدمة إرسال فعلية.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
