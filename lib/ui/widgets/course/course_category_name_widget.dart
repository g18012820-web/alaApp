import 'package:flutter/widgets.dart';

import '../../../base/constants/ui/app_colors.dart';
import '../../../base/constants/ui/app_text_styles.dart';

class CourseCategoryNameWidget extends StatelessWidget {
  const CourseCategoryNameWidget({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.current.transparentBlue, borderRadius: BorderRadius.circular(6)),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Text(name, style: AppTextStyles.bodyXSmallSemiBold.withPrimaryColor()),
    );
  }
}
