import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';

/// صفحة نص ثابت عامة تُستخدم لـ "سياسة الخصوصية" و"الشروط" و"حول التطبيق"
/// (راجع "⚙️ الإعدادات"). المحتوى الحالي نموذجي (placeholder)؛ المالك يجب
/// أن يستبدله بالنص القانوني الفعلي الخاص بمنصته قبل الإطلاق.
@RoutePage()
class StaticInfoPage extends StatelessWidget {
  final String title;
  final String content;

  const StaticInfoPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: CommonAppBar(text: title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
        child: Text(content, style: AppTextStyles.bodyMedium),
      ),
    );
  }
}
