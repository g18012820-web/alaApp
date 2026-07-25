import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/helper/checker.dart';
import 'package:flutter_bloc_template/ui/common/widget/universal_video_player.dart';
import 'package:gap/gap.dart';

import '../../../../base/constants/ui/app_colors.dart';
import '../../../../resource/generated/assets.gen.dart';

/// صفحة تشغيل الحصة — تعتمد على [UniversalVideoPlayer] الذي يدعم كل مصادر
/// الفيديو المذكورة في القسم 4 من ملف المواصفات (رفع مباشر، منصات الفيديو،
/// التخزين السحابي، بروتوكولات البث) عبر اكتشاف تلقائي للمصدر من الرابط.
@RoutePage()
class LessonVideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String? title;
  final String? lessonId;
  final String? watermarkText;

  const LessonVideoPlayerPage({super.key, required this.videoUrl, this.title, this.lessonId, this.watermarkText});

  @override
  State<LessonVideoPlayerPage> createState() => _LessonVideoPlayerPageState();
}

class _LessonVideoPlayerPageState extends State<LessonVideoPlayerPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight, DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: UniversalVideoPlayer(videoUrl: widget.videoUrl, title: widget.title, lessonId: widget.lessonId, watermarkText: widget.watermarkText),
            ),
            Positioned(
              top: 15,
              left: Dimens.paddingHorizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Assets.icons.arrowLeft.svg(colorFilter: ColorFilter.mode(AppColors.current.otherWhite, BlendMode.srcIn)),
                    onPressed: () => AutoRouter.of(context).back(),
                  ),
                  if (!empty(widget.title)) ...[
                    const Gap(Dimens.paddingHorizontalLarge),
                    Flexible(
                      child: Text(
                        widget.title!,
                        style: AppTextStyles.h3Bold.withWhiteColor(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
