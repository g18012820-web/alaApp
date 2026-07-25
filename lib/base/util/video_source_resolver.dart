import 'package:flutter_bloc_template/domain/entity/course/video_source_type.dart';

/// يكتشف نوع مصدر الفيديو من الرابط الخام، ويبني رابط التضمين (iframe) المناسب
/// عند الحاجة. هذه هي "طبقة الاكتشاف" التي يعتمد عليها [UniversalVideoPlayer].
abstract final class VideoSourceResolver {
  VideoSourceResolver._();

  /// يكتشف [VideoSourceType] تلقائيًا اعتمادًا على نمط الرابط.
  /// المالك يستطيع أيضًا فرض النوع يدويًا عند إضافة الحصة (إعدادات المصدر §4.7)
  /// بدل الاعتماد على الاكتشاف التلقائي فقط.
  static VideoSourceType detect(String rawUrl) {
    final url = rawUrl.trim().toLowerCase();

    // صيغ الملفات المباشرة
    if (url.endsWith('.m3u8')) return VideoSourceType.hls;
    if (url.endsWith('.mpd')) return VideoSourceType.dash;
    if (url.startsWith('rtmp://') || url.startsWith('rtmps://')) return VideoSourceType.rtmp;
    if (url.endsWith('.mp4')) return VideoSourceType.mp4;
    if (url.endsWith('.webm')) return VideoSourceType.webm;
    if (url.endsWith('.mov')) return VideoSourceType.mov;
    if (url.endsWith('.avi')) return VideoSourceType.avi;
    if (url.endsWith('.mkv')) return VideoSourceType.mkv;

    // منصات الفيديو
    if (url.contains('youtube.com') || url.contains('youtu.be')) return VideoSourceType.youtube;
    if (url.contains('vimeo.com')) return VideoSourceType.vimeo;
    if (url.contains('dailymotion.com') || url.contains('dai.ly')) return VideoSourceType.dailymotion;
    if (url.contains('facebook.com') || url.contains('fb.watch')) return VideoSourceType.facebook;
    if (url.contains('twitter.com') || url.contains('x.com')) return VideoSourceType.x;
    if (url.contains('instagram.com')) return VideoSourceType.instagram;
    if (url.contains('tiktok.com')) return VideoSourceType.tiktok;
    if (url.contains('twitch.tv')) return VideoSourceType.twitch;
    if (url.contains('loom.com')) return VideoSourceType.loom;
    if (url.contains('wistia.com') || url.contains('wi.st')) return VideoSourceType.wistia;
    if (url.contains('brightcove.net') || url.contains('bcove')) return VideoSourceType.brightcove;
    if (url.contains('jwplayer.com') || url.contains('jwpsrv.com')) return VideoSourceType.jwPlayer;
    if (url.contains('sproutvideo.com')) return VideoSourceType.sproutVideo;
    if (url.contains('t.me') || url.contains('telegram.org')) return VideoSourceType.telegram;

    // تخزين سحابي مخصص للفيديو
    if (url.contains('.b-cdn.net') || url.contains('bunnycdn.com')) return VideoSourceType.bunnyStream;
    if (url.contains('cloudflarestream.com') || url.contains('videodelivery.net')) return VideoSourceType.cloudflareStream;
    if (url.contains('.s3.') || url.contains('s3.amazonaws.com')) return VideoSourceType.awsS3;
    if (url.contains('storage.googleapis.com')) return VideoSourceType.googleCloudStorage;
    if (url.contains('.blob.core.windows.net')) return VideoSourceType.azureBlob;
    if (url.contains('.digitaloceanspaces.com')) return VideoSourceType.digitalOceanSpaces;
    if (url.contains('wasabisys.com')) return VideoSourceType.wasabi;
    if (url.contains('backblazeb2.com')) return VideoSourceType.backblaze;

    // تخزين عام
    if (url.contains('drive.google.com')) return VideoSourceType.googleDrive;
    if (url.contains('dropbox.com')) return VideoSourceType.dropbox;
    if (url.contains('1drv.ms') || url.contains('onedrive.live.com')) return VideoSourceType.oneDrive;
    if (url.contains('box.com')) return VideoSourceType.box;
    if (url.contains('pcloud.com')) return VideoSourceType.pCloud;
    if (url.contains('mega.nz') || url.contains('mega.io')) return VideoSourceType.mega;
    if (url.contains('terabox.com') || url.contains('1024terabox.com')) return VideoSourceType.terabox;

    return VideoSourceType.directLink;
  }

  /// يبني رابط iframe الرسمي القابل للتضمين لمنصات [VideoPlaybackMode.embed].
  /// يُعاد الرابط الأصلي كما هو إن تعذّر تحويله (fallback آمن).
  static String buildEmbedUrl(String rawUrl, VideoSourceType type) {
    final url = rawUrl.trim();
    switch (type) {
      case VideoSourceType.youtube:
        final id = _extractYoutubeId(url);
        return id != null ? 'https://www.youtube.com/embed/$id?autoplay=1&playsinline=1' : url;
      case VideoSourceType.vimeo:
        final id = _extractLastPathSegment(url);
        return id != null ? 'https://player.vimeo.com/video/$id' : url;
      case VideoSourceType.dailymotion:
        final id = _extractLastPathSegment(url);
        return id != null ? 'https://www.dailymotion.com/embed/video/$id' : url;
      case VideoSourceType.facebook:
        return 'https://www.facebook.com/plugins/video.php?href=${Uri.encodeComponent(url)}&show_text=0';
      case VideoSourceType.x:
        // منصة X لا توفر iframe تضمين فيديو رسميًا مفتوحًا؛ يُعرض عبر صفحة التغريدة نفسها.
        return url;
      case VideoSourceType.instagram:
        return '${url.split('?').first.replaceAll(RegExp(r'/$'), '')}/embed';
      case VideoSourceType.tiktok:
        return url; // تيك توك يتطلب TikTok embed.js — يُعرض عبر صفحته مباشرة داخل WebView
      case VideoSourceType.twitch:
        final id = _extractLastPathSegment(url);
        return id != null ? 'https://player.twitch.tv/?video=$id&parent=localhost' : url;
      case VideoSourceType.loom:
        final id = _extractLastPathSegment(url);
        return id != null ? 'https://www.loom.com/embed/$id' : url;
      case VideoSourceType.wistia:
        final id = _extractLastPathSegment(url);
        return id != null ? 'https://fast.wistia.net/embed/iframe/$id' : url;
      case VideoSourceType.brightcove:
      case VideoSourceType.jwPlayer:
      case VideoSourceType.sproutVideo:
      case VideoSourceType.telegram:
      case VideoSourceType.iframe:
        return url; // هذه المنصات عادة يزوّد المالك رابط iframe/embed جاهز عند الإضافة (§4.7)
      case VideoSourceType.googleDrive:
        final id = RegExp(r'/d/([a-zA-Z0-9_-]+)').firstMatch(url)?.group(1);
        return id != null ? 'https://drive.google.com/file/d/$id/preview' : url;
      case VideoSourceType.dropbox:
        return url.contains('dl=0') ? url.replaceAll('dl=0', 'raw=1') : url;
      case VideoSourceType.oneDrive:
        return url.replaceAll('embed=video', 'embed');
      case VideoSourceType.box:
        return url.replaceAll('/s/', '/embed/s/');
      default:
        return url;
    }
  }

  static String? _extractYoutubeId(String url) {
    final short = RegExp(r'youtu\.be/([a-zA-Z0-9_-]{6,})').firstMatch(url);
    if (short != null) return short.group(1);
    final long = RegExp(r'[?&]v=([a-zA-Z0-9_-]{6,})').firstMatch(url);
    if (long != null) return long.group(1);
    final shorts = RegExp(r'youtube\.com/shorts/([a-zA-Z0-9_-]{6,})').firstMatch(url);
    if (shorts != null) return shorts.group(1);
    return null;
  }

  static String? _extractLastPathSegment(String url) {
    final clean = url.split('?').first.replaceAll(RegExp(r'/$'), '');
    final segments = clean.split('/');
    return segments.isNotEmpty ? segments.last : null;
  }
}
