import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/base/util/current_student_session.dart';
import 'package:flutter_bloc_template/data/repository/favorites/favorites_store.dart';
import 'package:flutter_bloc_template/data/repository/owner/owner_content_repository.dart';
import 'package:gap/gap.dart';

/// شاشة "❤️ المفضلة": عرض الدورات المفضّلة مع إمكانية الإزالة وإعادة الترتيب
/// بالسحب.
@RoutePage()
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String? _studentId;

  @override
  void initState() {
    super.initState();
    CurrentStudentSession.getCurrentStudentId().then((id) {
      if (mounted) setState(() => _studentId = id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_studentId == null) {
      return CommonScaffold(appBar: CommonAppBar(text: 'المفضلة'), body: const Center(child: Text('سجّل الدخول أولاً')));
    }
    final favStore = FavoritesStore.instance;
    final ownerRepo = OwnerContentRepository.instance;

    return CommonScaffold(
      appBar: CommonAppBar(text: 'المفضلة'),
      body: AnimatedBuilder(
        animation: Listenable.merge([favStore, ownerRepo]),
        builder: (context, _) {
          final favoriteIds = favStore.favoritesOf(_studentId!);
          final allCourses = ownerRepo.subjects.expand((s) => ownerRepo.coursesOf(s.id)).toList();
          final favoriteCourses = favoriteIds.map((id) => allCourses.where((c) => c.id == id)).where((w) => w.isNotEmpty).map((w) => w.first).toList();

          if (favoriteCourses.isEmpty) {
            return const Center(child: Text('لا توجد دورات مفضّلة بعد'));
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.all(Dimens.paddingHorizontalLarge),
            itemCount: favoriteCourses.length,
            onReorder: (oldIndex, newIndex) => favStore.reorder(_studentId!, oldIndex, newIndex),
            itemBuilder: (context, index) {
              final course = favoriteCourses[index];
              return Container(
                key: ValueKey(course.id),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(border: Border.all(color: AppColors.current.greyscale200), borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    const Icon(Icons.drag_handle),
                    const Gap(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(course.title, style: AppTextStyles.bodyLargeBold),
                          Text('${course.price} د.ج', style: AppTextStyles.bodySmallMedium),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.favorite, color: AppColors.current.error),
                      onPressed: () => favStore.toggle(_studentId!, course.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
