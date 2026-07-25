import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:gap/gap.dart';

import '../../base/constants/ui/app_colors.dart';

class ViaWidget extends StatelessWidget {
  const ViaWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Divider(color: AppColors.current.greyscale200)),
          const Gap(Dimens.paddingHorizontal),
          Text(title,
              style: AppTextStyles.bodyXLargeSemiBold.copyWith(color: AppColors.current.greyscale700)),
          const Gap(Dimens.paddingHorizontal),
          Expanded(child: Divider(color: AppColors.current.greyscale200)),
        ],
      ),
    );
  }
}