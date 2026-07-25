import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../base/constants/ui/app_text_styles.dart';
import '../../../base/constants/ui/dimens.dart';
import '../../../resource/generated/assets.gen.dart';

class OnboardingPageViewWidget extends StatelessWidget {
  const OnboardingPageViewWidget({super.key, required this.path, required this.title});

  final String path;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingHorizontalLarge),
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          const Gap(kToolbarHeight),
          AspectRatio(
            aspectRatio: .97,
            child: AssetGenImage(path).image(),
          ),
          Center(child: Text(title, style: AppTextStyles.h2Bold, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}
