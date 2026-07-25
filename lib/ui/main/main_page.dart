import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/di/di.dart';
import 'package:flutter_bloc_template/navigation/router.dart';

import '../../base/constants/ui/app_colors.dart';
import '../../base/constants/ui/app_text_styles.dart';
import '../../base/navigator/app_navigator.dart';
import '../../domain/entity/enum/enum.dart';
import '../../navigation/app_navigator_impl.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: SL.get<AppRouter>().tabRoutes,
      bottomNavigationBuilder: (context, tabsRouter) {
        (SL.get<AppNavigator>() as AppNavigatorImpl).tabsRouter = tabsRouter;
        return Container(
          child: BottomNavigationBar(
            onTap: (index) {
              tabsRouter.setActiveIndex(index);
            },
            currentIndex: tabsRouter.activeIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedLabelStyle: AppTextStyles.bodyXSmallBold.copyWith(color: AppColors.current.primary500),
            unselectedLabelStyle: AppTextStyles.bodyXSmallBold.copyWith(color: AppColors.current.greyscale500),
            unselectedFontSize: 12,
            selectedFontSize: 12,
            useLegacyColorScheme: false,
            items: BottomTab.values
                .mapIndexed<BottomNavigationBarItem>((idx, e) => BottomNavigationBarItem(
                      icon: e.fromWidget(idx == tabsRouter.activeIndex),
                      label: e.fromTitle(),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
