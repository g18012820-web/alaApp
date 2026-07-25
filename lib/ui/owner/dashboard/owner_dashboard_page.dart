import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:gap/gap.dart';

/// نقطة دخول لوحة تحكم المالك (القسم 14 من ملف المواصفات).
/// هذه أول لبنة من "اللوحة الخارقة" الكاملة — إحصائيات المرحلة القادمة
/// (المحفظة، الأكواد، الطلاب...) ستُضاف تباعًا مع كل مرحلة من خارطة الطريق.
@RoutePage()
class OwnerDashboardPage extends StatelessWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = OwnerContentRepository.instance;
    return CommonScaffold(
      appBar: CommonAppBar(text: 'لوحة تحكم المالك', automaticallyImplyLeading: false, leadingWidth: 0, leadingIcon: LeadingIcon.none),
      body: AnimatedBuilder(
        animation: repo,
        builder: (context, _) {
          final totalCourses = repo.subjects.fold<int>(0, (sum, s) => sum + repo.coursesOf(s.id).length);
          final totalLessons = repo.subjects.fold<int>(0, (sum, s) => sum + repo.coursesOf(s.id).fold<int>(0, (sub, c) => sub + repo.lessonsOf(c.id).length));
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _statCard('المواد', repo.subjects.length.toString(), AppColors.current.primary500),
                    const Gap(12),
                    _statCard('الدورات', totalCourses.toString(), Colors.orange),
                    const Gap(12),
                    _statCard('الحصص', totalLessons.toString(), Colors.teal),
                  ],
                ),
                const Gap(12),
                Row(
                  children: [
                    _statCard('الطلاب', repo.students.length.toString(), Colors.purple),
                    const Gap(12),
                    _statCard('الأساتذة', repo.teachers.length.toString(), Colors.indigo),
                    const Gap(12),
                    _statCard('محظورون', repo.students.where((s) => s.isBlocked).length.toString(), AppColors.current.error),
                  ],
                ),
                const Gap(Dimens.paddingVerticalLarge),
                Text('الإدارة', style: AppTextStyles.h3Bold),
                const Gap(Dimens.paddingVerticalMedium),
                _menuCard(
                  context,
                  title: 'إدارة الطلاب',
                  subtitle: 'إنشاء، تعديل، حظر، تعديل الرصيد',
                  icon: Icons.people_outline,
                  onTap: () => AutoRouter.of(context).push(const OwnerStudentsRoute()),
                ),
                const Gap(12),
                _menuCard(
                  context,
                  title: 'إدارة الأساتذة',
                  subtitle: 'ملفات تعريفية بلا حساب دخول',
                  icon: Icons.school_outlined,
                  onTap: () => AutoRouter.of(context).push(const OwnerTeachersRoute()),
                ),
                const Gap(12),
                _menuCard(
                  context,
                  title: 'إدارة المواد',
                  subtitle: 'إضافة/تعديل/حذف المواد الدراسية',
                  icon: Icons.category_outlined,
                  onTap: () => AutoRouter.of(context).push(const OwnerSubjectsRoute()),
                ),
                const Gap(12),
                _menuCard(
                  context,
                  title: 'إدارة الدورات والحصص',
                  subtitle: 'اختر مادة أولاً لعرض دوراتها',
                  icon: Icons.video_library_outlined,
                  onTap: () {
                    if (repo.subjects.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أضف مادة أولاً قبل إضافة دورات')));
                      return;
                    }
                    AutoRouter.of(context).push(const OwnerSubjectsRoute());
                  },
                ),
                const Gap(20),
                Text('بيانات الدخول', style: AppTextStyles.h3Bold),
                const Gap(Dimens.paddingVerticalMedium),
                _menuCard(
                  context,
                  title: 'إدارة الشحن',
                  subtitle: 'مراجعة طلبات شحن الرصيد وقبولها/رفضها',
                  icon: Icons.receipt_long_outlined,
                  onTap: () => AutoRouter.of(context).push(const OwnerChargingRoute()),
                ),
                const Gap(12),
                _menuCard(
                  context,
                  title: 'إدارة الأكواد',
                  subtitle: 'توليد أكواد رصيد/دورة وإدارتها',
                  icon: Icons.confirmation_number_outlined,
                  onTap: () => AutoRouter.of(context).push(const OwnerCodesRoute()),
                ),
                const Gap(12),
                _menuCard(
                  context,
                  title: 'بيانات دخول المالك',
                  subtitle: 'تغيير بريد وكلمة مرور المالك',
                  icon: Icons.admin_panel_settings_outlined,
                  onTap: () => AutoRouter.of(context).push(const OwnerCredentialsRoute()),
                ),
                const Gap(12),
                _menuCard(
                  context,
                  title: 'إعدادات التسجيل',
                  subtitle: 'اشتراط تفعيل الحساب برمز',
                  icon: Icons.verified_user_outlined,
                  onTap: () => AutoRouter.of(context).push(const OwnerRegistrationSettingsRoute()),
                ),
                const Gap(20),
                Text('قريبًا (المراحل القادمة)', style: AppTextStyles.h3Bold),
                const Gap(4),
                Text('هذه الأقسام موثّقة في المواصفات وتحتاج خادمًا حقيقيًا لتعمل بصدق دون بيانات وهمية.', style: AppTextStyles.bodySmallMedium),
                const Gap(Dimens.paddingVerticalMedium),
                ..._comingSoon.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _menuCard(context, title: e, subtitle: 'قيد الإنشاء — مرحلة قادمة', icon: Icons.hourglass_empty, disabled: true, onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"$e" ضمن مرحلة قادمة من خارطة الطريق')));
                      }),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.h2Bold.copyWith(color: color)),
            const Gap(4),
            Text(label, style: AppTextStyles.bodySmallMedium),
          ],
        ),
      ),
    );
  }

  static const List<String> _comingSoon = [
    'الإشعارات المستهدفة',
    'الجلسات النشطة والأجهزة',
    'سجلات النشاط (Audit Logs)',
    'الإحصائيات والرسوم البيانية',
    'الإعدادات العامة للمنصة',
  ];

  Widget _menuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool disabled = false,
  }) {
    final color = disabled ? AppColors.current.greyscale400 : AppColors.current.primary500;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyLargeBold),
                  Text(subtitle, style: AppTextStyles.bodySmallMedium),
                ],
              ),
            ),
            const Icon(Icons.arrow_back_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
