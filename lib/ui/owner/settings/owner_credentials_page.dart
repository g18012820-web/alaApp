import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/base/util/owner_auth_store.dart';
import 'package:gap/gap.dart';

/// تغيير بريد وكلمة مرور المالك (يُستخدمان في شاشة الدخول الموحّدة لتمييز
/// المالك عن الطالب — راجع `docs/owner-login-integration.md`).
@RoutePage()
class OwnerCredentialsPage extends StatefulWidget {
  const OwnerCredentialsPage({super.key});

  @override
  State<OwnerCredentialsPage> createState() => _OwnerCredentialsPageState();
}

class _OwnerCredentialsPageState extends State<OwnerCredentialsPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final email = await OwnerAuthStore.getEmail();
    final password = await OwnerAuthStore.getPassword();
    if (!mounted) return;
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
      _confirmController.text = password;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('كلمتا المرور غير متطابقتين')));
      return;
    }
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا يمكن ترك الحقول فارغة')));
      return;
    }
    await OwnerAuthStore.updateCredentials(email: _emailController.text.trim(), password: _passwordController.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث بيانات دخول المالك بنجاح')));
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(text: 'بيانات دخول المالك'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.amber.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      '⚠️ هذه البيانات مخزّنة محليًا على هذا الجهاز فقط طالما لا يوجد خادم حقيقي. غيّرها فورًا عن القيم الافتراضية.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const Gap(20),
                  TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'بريد المالك', border: OutlineInputBorder())),
                  const Gap(12),
                  TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'كلمة المرور', border: OutlineInputBorder())),
                  const Gap(12),
                  TextField(controller: _confirmController, decoration: const InputDecoration(labelText: 'تأكيد كلمة المرور', border: OutlineInputBorder())),
                  const Gap(20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500, padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: _save,
                      child: Text('حفظ', style: AppTextStyles.bodyLargeBold.copyWith(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
