import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/domain/entity/course/promote_entity.dart';
import 'package:flutter_bloc_template/resource/generated/assets.gen.dart';
import 'package:flutter_bloc_template/ui/onboarding/components/dot_widget.dart';
import 'package:gap/gap.dart';

class HomeBannerSlideWidget extends StatefulWidget {
  const HomeBannerSlideWidget({super.key, required this.items});

  final List<PromoteEntity> items;

  @override
  State<HomeBannerSlideWidget> createState() => _HomeBannerSlideWidgetState();
}

class _HomeBannerSlideWidgetState extends State<HomeBannerSlideWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.current.gradientBlue, boxShadow: [
          BoxShadow(
            color: AppColors.current.primary500.withOpacity(.25),
            offset: const Offset(4, 8),
            blurRadius: 24,
          )
        ]),
        child: Stack(
          children: [
            PageView.builder(
              onPageChanged: (i) {
                setState(() {
                  index = i;
                });
              },
              scrollDirection: Axis.horizontal,
              itemCount: widget.items.length,
              itemBuilder: (BuildContext context, int index) {
                return _item(widget.items[index]);
              },
            ),
            Positioned(child: IgnorePointer(ignoring: true, child: Assets.icons.vector1.svg())),
            Positioned(bottom: 0, right: 0, child: IgnorePointer(ignoring: true, child: Assets.icons.vector2.svg())),
            if (widget.items.isNotEmpty)  Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Align(
                alignment: Alignment.center,
                child: DotWidget(index: index, total: widget.items.length, selectedColor: AppColors.current.otherWhite,),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(PromoteEntity item) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.discount} OFF', style: AppTextStyles.bodyMediumSemiBold.copyWith(color: AppColors.current.otherWhite)),
                    const Gap(8),
                    Text(item.title, style: AppTextStyles.h4Bold.copyWith(color: AppColors.current.otherWhite)),
                  ],
                ),
                const Gap(12),
                Text(
                  item.discount,
                  style: AppTextStyles.h1Bold.copyWith(color: AppColors.current.otherWhite),
                )
              ],
            ),
          ),
          const Gap(Dimens.paddingVertical),
          Text(
            item.description,
            style: AppTextStyles.bodyLargeMedium.copyWith(color: AppColors.current.otherWhite),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
