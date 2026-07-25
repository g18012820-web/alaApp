

import 'package:flutter/material.dart';

import '../../../../../base/constants/ui/app_colors.dart';
import '../../../../../base/constants/ui/dimens.dart';
import '../../../../../domain/entity/enum/enum.dart';

class CoursePersistentHeaderDelegate extends SliverPersistentHeaderDelegate {

  final ValueChanged<int> onTap;

  CoursePersistentHeaderDelegate({required this.onTap});

  @override
  double get minExtent => kToolbarHeight;
  @override
  double get maxExtent => kToolbarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.current.otherWhite,
      child: SizedBox.expand(
        child: TabBar(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingHorizontalLarge),
          tabs: CourseTab.values.map<Widget>((tab) => Tab(text: tab.fromTitle())).toList(),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(CoursePersistentHeaderDelegate oldDelegate) {
    return true;
  }
}