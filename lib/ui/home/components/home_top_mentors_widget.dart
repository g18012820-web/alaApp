import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/domain/entity/course/mentor_entity.dart';
import 'package:gap/gap.dart';

class HomeTopMentorsWidget extends StatelessWidget {
  const HomeTopMentorsWidget({super.key, required this.items});

  final List<MentorEntity> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Top Mentors', style: AppTextStyles.h5Bold),
            Text('See All', style: AppTextStyles.bodyLargeBold.withPrimaryColor()),
          ],
        ),
        const Gap(Dimens.paddingVerticalLarge),
        SizedBox(
          height: 110,
          child: ListView.separated(
            separatorBuilder: (_, __) => const Gap(Dimens.paddingHorizontal),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) => _item(items[index]),
          ),
        )
      ],
    );
  }

  Widget _item(MentorEntity item) {
    return Column(
      children: [
        const CircleAvatar(radius: 36),
        const Gap(8),
        Text(item.name, style: AppTextStyles.bodyLargeSemiBold),
      ],
    );
  }
}
