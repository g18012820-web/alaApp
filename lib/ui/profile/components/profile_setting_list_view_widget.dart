import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/util/app_settings_controller.dart';
import 'package:flutter_bloc_template/base/util/current_student_session.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:flutter_bloc_template/resource/generated/assets.gen.dart';
import 'package:flutter_bloc_template/resource/generated/l10n.dart';
import 'package:gap/gap.dart';

import '../../../base/constants/ui/app_colors.dart';

class ProfileSettingListViewWidget extends StatelessWidget {
  const ProfileSettingListViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _item(
            onTap: () => AutoRouter.of(context).push(const StudentSubjectsRoute()),
            label: 'تصفّح المواد والدورات',
            icon: Assets.icons.documentBold.svg()),
        _item(
          onTap: () {
            AutoRouter.of(context).push(const EditProfileRoute());
          },
          label: 'Edit Profile',
          icon: Assets.icons.profileCurved.svg(),
        ),
        _item(
            onTap: () => AutoRouter.of(context).push(const SettingNotificationRoute()),
            label: 'Notification',
            icon: Assets.icons.notificationCurved.svg()),
        _item(
            onTap: () => AutoRouter.of(context).push(const WalletRoute()), label: S.current.wallet, icon: Assets.icons.walletCurved.svg()),
        _item(
            onTap: () => AutoRouter.of(context).push(const FavoritesRoute()),
            label: 'المفضلة',
            icon: Assets.icons.heartBold.svg()),
        _item(onTap: () {}, label: 'Security', icon: Assets.icons.shieldDoneCurved.svg()),
        _item(
          onTap: () async {
            final isArabic = AppSettingsController.locale.value.languageCode == 'ar';
            await AppSettingsController.setLanguage(isArabic ? 'en' : 'ar');
          },
          label: 'Language',
          icon: Assets.icons.moreCircleCurved.svg(),
          trailing: ValueListenableBuilder<Locale>(
            valueListenable: AppSettingsController.locale,
            builder: (context, locale, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(locale.languageCode == 'ar' ? 'العربية' : 'English'),
                  const Gap(20),
                  Assets.icons.arrowRight2.svg(),
                ],
              );
            },
          ),
        ),
        _item(
            onTap: () {},
            label: 'Dark Mode',
            icon: Assets.icons.showCurved.svg(),
            trailing: ValueListenableBuilder<ThemeMode>(
              valueListenable: AppSettingsController.themeMode,
              builder: (context, mode, _) {
                final enabled = mode == ThemeMode.dark;
                return GestureDetector(
                  onTap: () => AppSettingsController.toggleDarkMode(!enabled),
                  child: enabled ? Assets.icons.toggleEnable.svg() : Assets.icons.toggleDisabled.svg(),
                );
              },
            )),
        _item(
            onTap: () => AutoRouter.of(context).push(StaticInfoRoute(
                  title: 'سياسة الخصوصية',
                  content: 'هذا نص نموذجي لسياسة الخصوصية. يجب على المالك استبداله بالسياسة القانونية الفعلية للمنصة قبل الإطلاق للجمهور.',
                )),
            label: 'Privacy Policy',
            icon: Assets.icons.lockCurved.svg()),
        _item(
            onTap: () => AutoRouter.of(context).push(StaticInfoRoute(
                  title: 'الشروط والأحكام',
                  content: 'هذا نص نموذجي للشروط والأحكام. يجب على المالك استبداله بالنص القانوني الفعلي للمنصة قبل الإطلاق للجمهور.',
                )),
            label: 'الشروط والأحكام',
            icon: Assets.icons.documentBold.svg()),
        _item(
            onTap: () => AutoRouter.of(context).push(StaticInfoRoute(
                  title: 'حول التطبيق',
                  content: 'منصة تعليمية عربية احترافية.\nالإصدار: 1.0.0 (نسخة تطوير)',
                )),
            label: 'حول التطبيق',
            icon: Assets.icons.infoSquareCurved.svg()),
        _item(
            onTap: () => AutoRouter.of(context).push(const HelpCenterRoute()),
            label: 'Help Center',
            icon: Assets.icons.infoSquareCurved.svg()),
        _item(
            onTap: () => AutoRouter.of(context).push(StaticInfoRoute(
                  title: 'التواصل معنا',
                  content: 'للتواصل معنا:\nالبريد الإلكتروني: support@platform.com\nهاتف الدعم: 0550000000',
                )),
            label: 'التواصل معنا',
            icon: Assets.icons.usersCurve.svg()),
        _item(
          onTap: () async {
            await CurrentStudentSession.clear();
            if (context.mounted) {
              AutoRouter.of(context).replaceAll([const LoginRoute()]);
            }
          },
          label: 'Logout',
          labelStyle: AppTextStyles.bodyXLargeBold.copyWith(color: AppColors.current.error),
          icon: Assets.icons.logoutCurved.svg(
              colorFilter: ColorFilter.mode(
            AppColors.current.error,
            BlendMode.srcIn,
          )),
          trailing: const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _item({
    required VoidCallback? onTap,
    required String label,
    required Widget icon,
    Widget? trailing,
    TextStyle? labelStyle,
    // bool visibleBorderBottom = true,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                icon,
                const Gap(20),
                Text(label, style: labelStyle ?? AppTextStyles.bodyXLargeBold),
              ],
            ),
            trailing ?? Assets.icons.arrowRight2.svg(width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}
