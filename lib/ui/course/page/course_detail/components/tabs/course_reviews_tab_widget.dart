import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_template/base/shared_view/common_expandable_text.dart';
import 'package:flutter_bloc_template/base/shared_view/common_image_view.dart';
import 'package:flutter_bloc_template/domain/entity/course/course_entity.dart';
import 'package:flutter_bloc_template/domain/entity/course/review_entity.dart';
import 'package:flutter_bloc_template/domain/entity/enum/enum.dart';
import 'package:flutter_bloc_template/ui/widgets/custom_chip_widget.dart';
import 'package:gap/gap.dart';

import '../../../../../../base/constants/ui/app_colors.dart';
import '../../../../../../base/constants/ui/app_text_styles.dart';
import '../../../../../../base/constants/ui/dimens.dart';
import '../../../../../../resource/generated/assets.gen.dart';
import '../../../../../widgets/course/course_rating_widget.dart';

class CourseReviewsTabWidget extends StatelessWidget {
  const CourseReviewsTabWidget({super.key, required this.reviews, required this.course});

  final List<ReviewEntity> reviews;
  final CourseEntity course;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingHorizontalLarge).copyWith(top: Dimens.paddingVerticalLarge),
      child: Column(
        children: [
          CourseRatingWidget(
            total: course.reviewsCount,
            rating: course.rating,
            textStyle: AppTextStyles.h5Bold,
            iconSize: 24,
          ),
          const Gap(Dimens.paddingVerticalLarge),
          _filter(),
          const Gap(Dimens.paddingVerticalLarge),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const Gap(Dimens.paddingVerticalLarge),
              itemBuilder: (_, int index) {
                final item = reviews[index];
                return _item(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(ReviewEntity item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const CommonImageView(imageUrl: '', width: 48, height: 48, radius: 100),
                    const Gap(16),
                    Expanded(
                        child: Text(
                      'Marielle Wigington',
                      style: AppTextStyles.bodyLargeBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                ),
              ),
              const Gap(12),
              Row(
                children: [
                  CustomChipWidget(label: _label('5'), onSelected: (val) {}),
                  const Gap(12),
                  Assets.icons.moreCircleLight.svg(),
                ],
              )
            ],
          ),
        ),
        const Gap(12),
        CommonExpandableText(content: item.comment),
        const Gap(12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Assets.icons.heartBold.svg(width: 24, colorFilter: const ColorFilter.mode(Color(0xffFF4D67), BlendMode.srcIn)),
            const Gap(8),
            Text('948', style: AppTextStyles.bodySmallSemiBold),
            const Gap(Dimens.paddingHorizontalLarge),
            Text('2 weeks ago', style: AppTextStyles.bodySmallSemiBold.copyWith(color: AppColors.current.greyscale700))
          ],
        )
      ],
    );
  }

  Widget _filter() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: RatingFilter.values.length,
        separatorBuilder: (_, __) => const Gap(12),
        itemBuilder: (_, int index) {
          final item = RatingFilter.values[index];
          bool selected = false;
          return CustomChipWidget(
            selected: selected,
            onSelected: (val) {},
            label: _label(item.fromTitle()),
          );
        },
      ),
    );
  }

  Widget _label(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Assets.icons.starBold.svg(width: 16, colorFilter: ColorFilter.mode(AppColors.current.primary500, BlendMode.srcIn)),
        const Gap(8),
        Text(
          title,
          style: AppTextStyles.bodyLargeSemiBold.withPrimaryColor(),
        )
      ],
    );
  }
}
