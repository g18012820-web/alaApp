import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/extension/duration_extension.dart';
import 'package:flutter_bloc_template/base/helper/checker.dart';
import 'package:flutter_bloc_template/base/util/screen_security.dart';
import 'package:flutter_bloc_template/base/util/watch_progress_store.dart';
import 'package:video_player/video_player.dart';

/// مشغّل الفيديو الأصلي (Native): لكل مصدر يُعطي رابط تشغيل مباشرًا (ملف
/// MP4/WEBM/MOV/AVI/MKV، بث HLS أو DASH، أو رابط تخزين سحابي مباشر).
///
/// يطبّق من مزايا "المشغّل الاحترافي الموحّد" (القسم 5) ما هو ممكن فعليًا على
/// مستوى العميل بدون خادم:
/// - التحكم بالسرعة (0.5x → 2x) ✅
/// - استكمال المشاهدة من آخر نقطة توقف ✅ (تخزين محلي، سيُزامَن مع الخادم لاحقًا)
/// - نسبة تقدّم لكل حصة ✅
/// - Watermark ديناميكي (اسم/بريد الطالب) ✅
/// - منع لقطة الشاشة/التسجيل (أندرويد) ✅ عبر FLAG_SECURE
/// - وضع الصوت فقط (خلفي) ✅ تقريبي: يواصل تشغيل الصوت مع تعتيم الفيديو
///   (ملاحظة صادقة: لا يبدّل إلى مسار صوتي منفصل موفّر للبيانات؛ هذا يتطلب
///   من الخادم توفير رابط صوت مستقل، وهو خارج نطاق هذا المشغّل وحده)
///
/// أما "جودة يدوية لمصادر HLS/DASH" و"روابط تشغيل موقّعة مؤقتة (Signed URLs)"
/// فهذه تتطلب دعمًا من الخادم و/أو مشغّل أعمق مستوى (مثل `media_kit`)، وموثّقة
/// كبند مفتوح في `docs/phase-2-design.md`.
class NativeVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String? title;

  /// معرّف الحصة، يُستخدم لحفظ/استرجاع آخر نقطة توقف ونسبة الإنجاز محليًا
  final String? lessonId;

  /// اسم/بريد الطالب الظاهر كعلامة مائية فوق الفيديو لمنع التسريب
  final String? watermarkText;

  const NativeVideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.title,
    this.lessonId,
    this.watermarkText,
  });

  @override
  State<NativeVideoPlayerWidget> createState() => _NativeVideoPlayerWidgetState();
}

class _NativeVideoPlayerWidgetState extends State<NativeVideoPlayerWidget> {
  static const List<double> _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  late VideoPlayerController _controller;
  bool _showOverlay = true;
  bool _hasError = false;
  bool _audioOnly = false;
  double _speed = 1.0;
  Timer? _hideControlsTimer;
  Timer? _progressSaveTimer;

  @override
  void initState() {
    super.initState();
    ScreenSecurity.enable();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) async {
        if (!mounted) return;
        final lessonId = widget.lessonId;
        if (lessonId != null && lessonId.isNotEmpty) {
          final resumeAt = await WatchProgressStore.getLastPosition(lessonId);
          if (resumeAt != null && resumeAt < _controller.value.duration) {
            await _controller.seekTo(resumeAt);
          }
        }
        setState(() {});
      }).catchError((_) {
        if (mounted) setState(() => _hasError = true);
      });
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _startHideControlsTimer();
    _startProgressAutoSave();
  }

  @override
  void dispose() {
    _saveProgress();
    ScreenSecurity.disable();
    _controller.dispose();
    _hideControlsTimer?.cancel();
    _progressSaveTimer?.cancel();
    super.dispose();
  }

  void _startProgressAutoSave() {
    _progressSaveTimer = Timer.periodic(const Duration(seconds: 5), (_) => _saveProgress());
  }

  void _saveProgress() {
    final lessonId = widget.lessonId;
    if (lessonId == null || lessonId.isEmpty) return;
    if (!_controller.value.isInitialized) return;
    WatchProgressStore.savePosition(lessonId, _controller.value.position, _controller.value.duration);
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showOverlay = false);
    });
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
    _startHideControlsTimer();
  }

  void _cycleSpeed() {
    final nextIndex = (_speeds.indexOf(_speed) + 1) % _speeds.length;
    setState(() => _speed = _speeds[nextIndex]);
    _controller.setPlaybackSpeed(_speed);
    _startHideControlsTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const ColoredBox(
        color: Colors.black,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(
            child: Text(
              'تعذّر تشغيل الفيديو، تحقق من الرابط أو اتصالك بالإنترنت',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() => _showOverlay = !_showOverlay);
        _startHideControlsTimer();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: _audioOnly
                  ? Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: const Icon(Icons.graphic_eq, color: Colors.white54, size: 48),
                    )
                  : VideoPlayer(_controller),
            )
          else
            const CircularProgressIndicator(color: Colors.white),

          if (!empty(widget.watermarkText) && _controller.value.isInitialized)
            Positioned(
              top: 8,
              right: 8,
              child: Opacity(
                opacity: 0.55,
                child: Text(
                  widget.watermarkText!,
                  style: const TextStyle(color: Colors.white, fontSize: 11, shadows: [Shadow(blurRadius: 3, color: Colors.black)]),
                ),
              ),
            ),

          if (_showOverlay && _controller.value.isInitialized)
            GestureDetector(
              onTap: _togglePlayPause,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), shape: BoxShape.circle),
                child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, size: 34, color: AppColors.current.primary500),
              ),
            ),

          if (_showOverlay && _controller.value.isInitialized)
            Positioned(
              top: 8,
              left: 8,
              child: Row(
                children: [
                  _pillButton('${_speed}x', _cycleSpeed),
                  const SizedBox(width: 8),
                  _pillButton(_audioOnly ? '🎧' : '🎬', () {
                    setState(() => _audioOnly = !_audioOnly);
                    _startHideControlsTimer();
                  }),
                ],
              ),
            ),

          if (_showOverlay && _controller.value.isInitialized)
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  Text(_controller.value.position.formatDuration(), style: AppTextStyles.bodySmallSemiBold.withWhiteColor()),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: VideoProgressIndicator(_controller, allowScrubbing: true, padding: EdgeInsets.zero),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_controller.value.duration.formatDuration(), style: AppTextStyles.bodySmallSemiBold.withWhiteColor()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _pillButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(100)),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
