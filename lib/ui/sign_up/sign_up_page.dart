import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_template/base/constants/algerian_states.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_button.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/base/shared_view/common_text_field.dart';
import 'package:flutter_bloc_template/base/util/activation_code_store.dart';
import 'package:flutter_bloc_template/base/util/current_student_session.dart';
import 'package:flutter_bloc_template/base/util/platform_settings_store.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:flutter_bloc_template/ui/widgets/social_auth_provider/social_auth_provider_page.dart';
import 'package:gap/gap.dart';

import '../../resource/generated/assets.gen.dart';
import '../../resource/generated/l10n.dart';
import '../widgets/auth_prompt_widget.dart';
import '../widgets/via_widget.dart';

/// شاشة التسجيل الكاملة (راجع "👤 التسجيل" في مواصفات تطبيق الطالب): الاسم،
/// اللقب، الهاتف، الولاية، البريد، كلمة المرور وتأكيدها — مع تحقق من الصيغة
/// وتكرار البريد/الهاتف، وربط مباشر بقائمة طلاب لوحة المالك.
@RoutePage()
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _stateController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _submitting = false;

  static final _emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
  static final _phoneRegex = RegExp(r'^0[5-7][0-9]{8}$'); // صيغة الهاتف الجزائري (05/06/07 + 8 أرقام)

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _pickState() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SizedBox(
          height: 420,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: algerianStates.length,
            itemBuilder: (context, index) {
              final state = algerianStates[index];
              return ListTile(
                title: Text(state),
                onTap: () {
                  setState(() => _stateController.text = state);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'البريد الإلكتروني مطلوب';
    if (!_emailRegex.hasMatch(email)) return 'صيغة البريد الإلكتروني غير صحيحة';
    final repo = OwnerContentRepository.instance;
    final duplicate = repo.students.any((s) => s.email.toLowerCase() == email.toLowerCase());
    if (duplicate) return 'هذا البريد الإلكتروني مسجّل مسبقًا';
    return null;
  }

  String? _validatePhone(String phone) {
    if (phone.isEmpty) return 'رقم الهاتف مطلوب';
    if (!_phoneRegex.hasMatch(phone)) return 'رقم هاتف جزائري غير صحيح (مثال: 0551234567)';
    final repo = OwnerContentRepository.instance;
    final duplicate = repo.students.any((s) => s.phoneNumber == phone);
    if (duplicate) return 'رقم الهاتف مسجّل مسبقًا';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.length < 8) return 'كلمة المرور يجب ألا تقل عن 8 محارف';
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    if (!hasLetter || !hasDigit) return 'كلمة المرور يجب أن تحتوي حروفًا وأرقامًا معًا';
    return null;
  }

  Future<void> _handleSubmit() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final state = _stateController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    final errors = <String>[];
    if (firstName.isEmpty) errors.add('الاسم مطلوب');
    if (lastName.isEmpty) errors.add('اللقب مطلوب');
    if (state.isEmpty) errors.add('الرجاء اختيار الولاية');

    final emailError = _validateEmail(email);
    if (emailError != null) errors.add(emailError);
    final phoneError = _validatePhone(phone);
    if (phoneError != null) errors.add(phoneError);
    final passwordError = _validatePassword(password);
    if (passwordError != null) errors.add(passwordError);
    if (password != confirm) errors.add('كلمة المرور وتأكيدها غير متطابقتين');

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errors.first)));
      return;
    }

    setState(() => _submitting = true);

    final studentId = OwnerContentRepository.instance.addStudent(fullName: '$firstName $lastName', email: email, phoneNumber: phone);
    await CurrentStudentSession.setCurrentStudentId(studentId);
    final activationRequired = await PlatformSettingsStore.isActivationRequired();

    if (!mounted) return;
    setState(() => _submitting = false);

    if (activationRequired) {
      final code = ActivationCodeStore.generate(email);
      // ⚠️ عرض تجريبي محلي بدل إرسال SMS/بريد حقيقي (راجع ActivationCodeStore)
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('رمز التفعيل (عرض تجريبي)'),
          content: Text('لا يوجد خادم SMS/بريد حقيقي بعد، لذلك نعرض الرمز مباشرة هنا:\n\n$code'),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('حسنًا'))],
        ),
      );
      if (!mounted) return;
      AutoRouter.of(context).replaceAll([ActivateAccountRoute(email: email)]);
    } else {
      AutoRouter.of(context).replaceAll([const MainRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(),
      bottomNavigationBar: AuthPromptWidget(
        message: S.current.already_have_an_account,
        actionText: S.current.sign_in,
        onActionTap: () {
          AutoRouter.of(context).push(const LoginRoute());
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingHorizontalLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(40),
            Text(S.current.create_ur_account, style: AppTextStyles.h1Bold.copyWith(height: 57.6 / 48)),
            const Gap(40),
            Row(
              children: [
                Expanded(
                  child: CommonTextField(controller: _firstNameController, hintText: S.current.full_name, prefixIconPath: Assets.icons.profile.path, onChanged: (val) {}),
                ),
                const Gap(12),
                Expanded(
                  child: CommonTextField(controller: _lastNameController, hintText: 'اللقب', prefixIconPath: Assets.icons.profile.path, onChanged: (val) {}),
                ),
              ],
            ),
            const Gap(16),
            CommonTextField(
              controller: _phoneController,
              hintText: S.current.phone_number,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              prefixIconPath: Assets.icons.message.path,
              onChanged: (val) {},
            ),
            const Gap(16),
            CommonTextField(
              controller: _stateController,
              hintText: S.current.state,
              readOnly: true,
              onTap: _pickState,
              prefixIconPath: Assets.icons.message.path,
              suffixIcon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (val) {},
            ),
            const Gap(16),
            CommonTextField(
              controller: _emailController,
              hintText: S.current.email,
              keyboardType: TextInputType.emailAddress,
              prefixIconPath: Assets.icons.message.path,
              onChanged: (val) {},
            ),
            const Gap(16),
            CommonTextField(
              controller: _passwordController,
              obscureText: true,
              hintText: S.current.password,
              prefixIconPath: Assets.icons.lock.path,
              onChanged: (val) {},
            ),
            const Gap(16),
            CommonTextField(
              controller: _confirmPasswordController,
              obscureText: true,
              hintText: S.current.confirm_password,
              prefixIconPath: Assets.icons.lock.path,
              onChanged: (val) {},
            ),
            const Gap(24),
            CommonButton(
              enable: !_submitting,
              onPressed: _handleSubmit,
              title: S.current.sign_up,
              fullWidth: true,
            ),
            const Gap(Dimens.paddingVerticalLarge),
            ViaWidget(title: S.current.or_continue_with.toLowerCase()),
            const Gap(Dimens.paddingVerticalLarge),
            const SocialAuthProviderPage(hideLabel: true),
          ],
        ),
      ),
    );
  }
}
