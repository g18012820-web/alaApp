import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_expandable_text.dart';
import 'package:flutter_bloc_template/base/shared_view/common_image_view.dart';
import 'package:flutter_bloc_template/domain/entity/course/course_entity.dart';
import 'package:flutter_bloc_template/domain/entity/course/mentor_entity.dart';
import 'package:gap/gap.dart';

import '../../../../../../base/constants/ui/app_colors.dart';
import '../../../../../../resource/generated/assets.gen.dart';

class CourseAboutTabWidget extends StatelessWidget {
  const CourseAboutTabWidget({super.key, required this.item});

  final CourseEntity item;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingHorizontalLarge).copyWith(top: Dimens.paddingVerticalLarge),
      children: [
        _mentor(item.mentor),
        const Gap(Dimens.paddingHorizontalLarge),
        Text('About Course', style: AppTextStyles.h5Bold),
        const Gap(12),
        CommonExpandableText(content: item.about, limitCharacters: 500),
        const Gap(Dimens.paddingVerticalLarge),
        Text('Tools', style: AppTextStyles.h5Bold),
      ],
    );
  }

  Widget _mentor(MentorEntity mentor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mentor', style: AppTextStyles.h5Bold),
        const Gap(Dimens.paddingVertical),
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CommonImageView(imageUrl: '', width: 60, height: 60, radius: 100),
                    const Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mentor.name, style: AppTextStyles.h6Bold),
                        const Gap(4),
                        Text(mentor.title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.current.greyscale700)),

                      ],
                    ),
                  ],
                ),
              ),
              const Gap(12),
              Assets.icons.chat.svg(colorFilter: ColorFilter.mode(AppColors.current.primary500, BlendMode.srcIn)),
            ],
          ),
        ),
      ],
    );
  }
}
