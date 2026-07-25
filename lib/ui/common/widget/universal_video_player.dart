import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/util/video_source_resolver.dart';
import 'package:flutter_bloc_template/domain/entity/course/video_source_type.dart';
import 'package:flutter_bloc_template/ui/common/widget/embed_video_player_widget.dart';
import 'package:flutter_bloc_template/ui/common/widget/external_only_video_widget.dart';
import 'package:flutter_bloc_template/ui/common/widget/native_video_player_widget.dart';

/// المشغّل الموحّد (Universal Player) — نقطة الدخول الوحيدة لتشغيل أي حصة فيديو
/// بغض النظر عن مصدرها. يكتشف المصدر تلقائيًا من الرابط، أو يعتمد [forcedType]
/// إن حدّده المالك يدويًا عند إضافة الحصة (إعدادات المصدر §4.7).
///
/// الاستخدام:
/// ```dart
/// UniversalVideoPlayer(videoUrl: lesson.videoUrl)
/// ```
class UniversalVideoPlayer extends StatelessWidget {
  final String videoUrl;
  final String? title;
  final VideoSourceType? forcedType;
  final String? lessonId;
  final String? watermarkText;

  const UniversalVideoPlayer({
    super.key,
    required this.videoUrl,
    this.title,
    this.forcedType,
    this.lessonId,
    this.watermarkText,
  });

  @override
  Widget build(BuildContext context) {
    if (videoUrl.trim().isEmpty) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: ColoredBox(color: Colors.black12, child: Center(child: Icon(Icons.videocam_off, color: Colors.white54))),
      );
    }

    final type = forcedType ?? VideoSourceResolver.detect(videoUrl);

    switch (type.mode) {
      case VideoPlaybackMode.native:
        return NativeVideoPlayerWidget(videoUrl: videoUrl, title: title, lessonId: lessonId, watermarkText: watermarkText);
      case VideoPlaybackMode.embed:
        final embedUrl = VideoSourceResolver.buildEmbedUrl(videoUrl, type);
        return EmbedVideoPlayerWidget(embedUrl: embedUrl);
      case VideoPlaybackMode.external:
        return ExternalOnlyVideoWidget(url: videoUrl);
    }
  }
}
