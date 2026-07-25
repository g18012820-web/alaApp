import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/shared_view/common_button.dart';
import 'package:flutter_bloc_template/domain/entity/config/onboarding_entity.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:flutter_bloc_template/resource/generated/assets.gen.dart';
import 'package:flutter_bloc_template/ui/onboarding/components/dot_widget.dart';
import 'package:flutter_bloc_template/ui/onboarding/components/onboarding_page_view_widget.dart';
import 'package:gap/gap.dart';

import '../../base/helper/duration_provider.dart';
import '../../base/shared_view/common_bottom_navigator_bar_background.dart';
import '../../base/shared_view/common_scaffold.dart';
import '../../resource/generated/l10n.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int index = 0;
  final PageController _pageController = PageController();

  final items = <OnboardingEntity>[
    OnboardingEntity(
      path: Assets.images.frame.path,
      title: S.current.onboarding_1_title,
    ),
    OnboardingEntity(
      path: Assets.images.frame1.path,
      title: S.current.onboarding_2_title,
    ),
    OnboardingEntity(
      path: Assets.images.frame2.path,
      title: S.current.onboarding_3_title,
    ),
  ];

  bool get isLast => index == items.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      bottomNavigationBar: CommonBottomNavigatorBarBackground(
        visibleBorder: false,
        child: CommonButton(
          title: isLast ? S.current.get_started : S.current.next,
          onPressed: () {
            if (isLast) {
              AutoRouter.of(context).push(const LetInRoute());
              return;
            }
            _pageController.nextPage(duration: const ShortDuration(), curve: Curves.linear);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                physics: const ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (i) {
                  setState(() {
                    index = i;
                  });
                },
                children: items.map<Widget>((e) => OnboardingPageViewWidget(path: e.path, title: e.title)).toList(),
              ),
            ),
            DotWidget(index: index, total: items.length),
            const Gap(kToolbarHeight),
          ],
        ),
      ),
    );
  }
}
