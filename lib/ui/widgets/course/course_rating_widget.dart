import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../base/constants/ui/app_colors.dart';
import '../../../base/constants/ui/app_text_styles.dart';
import '../../../resource/generated/assets.gen.dart';

class CourseRatingWidget extends StatelessWidget {
  const CourseRatingWidget({
    super.key,
    required this.total,
    required this.rating,
    this.textStyle,
    this.iconSize,
  });

  final int total;
  final double rating;
  final TextStyle? textStyle;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Assets.icons.star.svg(width: iconSize ?? 16, height: iconSize ?? 16),
          const Gap(8),
          Text('$rating ($total reviews)',
              style: textStyle ?? AppTextStyles.bodySmallMedium.copyWith(color: AppColors.current.greyscale700)),
          // const Gap(8),
          // VerticalDivider(color: AppColors.current.greyscale700, width: 1, indent: 3, endIndent: 3),
          // const Gap(8),
          // Text('${NumberFormat("#,###").format(totalStudents)} students',
          //     style: textStyle ?? AppTextStyles.bodySmallMedium.copyWith(color: AppColors.current.greyscale700))
        ],
      ),
    );
  }
}
