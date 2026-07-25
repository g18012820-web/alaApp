/// جميع مصادر الفيديو المدعومة في المشغّل الموحّد (راجع القسم 4 من ملف المواصفات).
///
/// يُقسَّم كل مصدر إلى فئة تشغيل (`VideoPlaybackMode`) تحدّد **كيف** يُشغَّل فعليًا:
/// - `native`   : يُشغَّل مباشرة عبر `video_player` (ملف مباشر / HLS / DASH / رابط تخزين سحابي مباشر)
/// - `embed`    : يُعرض داخل WebView عبر iframe الرسمي للمنصة (يوتيوب، فيميو...)
/// - `external` : لا يوجد تضمين رسمي موثوق (MEGA, Terabox, pCloud) → يُفتح في متصفح مضمّن + زر "فتح خارجيًا"
enum VideoPlaybackMode { native, embed, external }

enum VideoSourceType {
  // ─── رفع مباشر / ملفات مباشرة ─────────────────────────────
  directUpload(VideoPlaybackMode.native),
  mp4(VideoPlaybackMode.native),
  webm(VideoPlaybackMode.native),
  mov(VideoPlaybackMode.native),
  avi(VideoPlaybackMode.native),
  mkv(VideoPlaybackMode.native),

  // ─── بروتوكولات البث ──────────────────────────────────────
  hls(VideoPlaybackMode.native), // M3U8
  dash(VideoPlaybackMode.native), // MPD
  rtmp(VideoPlaybackMode.native), // دعم محدود على أندرويد فقط عبر ExoPlayer، راجع ملاحظة أسفل الملف

  // ─── منصات الفيديو (Embed) ────────────────────────────────
  youtube(VideoPlaybackMode.embed),
  vimeo(VideoPlaybackMode.embed),
  dailymotion(VideoPlaybackMode.embed),
  facebook(VideoPlaybackMode.embed),
  x(VideoPlaybackMode.embed),
  instagram(VideoPlaybackMode.embed),
  tiktok(VideoPlaybackMode.embed),
  twitch(VideoPlaybackMode.embed),
  loom(VideoPlaybackMode.embed),
  wistia(VideoPlaybackMode.embed),
  brightcove(VideoPlaybackMode.embed),
  jwPlayer(VideoPlaybackMode.embed),
  sproutVideo(VideoPlaybackMode.embed),
  telegram(VideoPlaybackMode.embed),

  // ─── تخزين سحابي مخصص للفيديو (روابط تشغيل مباشرة/HLS) ─────
  bunnyStream(VideoPlaybackMode.native),
  cloudflareStream(VideoPlaybackMode.native),
  awsS3(VideoPlaybackMode.native),
  googleCloudStorage(VideoPlaybackMode.native),
  azureBlob(VideoPlaybackMode.native),
  digitalOceanSpaces(VideoPlaybackMode.native),
  wasabi(VideoPlaybackMode.native),
  backblaze(VideoPlaybackMode.native),
  minio(VideoPlaybackMode.native),

  // ─── خدمات تخزين عامة (روابط مشاركة → تحتاج تحويل لرابط تضمين) ─
  googleDrive(VideoPlaybackMode.embed),
  dropbox(VideoPlaybackMode.embed),
  oneDrive(VideoPlaybackMode.embed),
  box(VideoPlaybackMode.embed),
  pCloud(VideoPlaybackMode.external),
  mega(VideoPlaybackMode.external),
  terabox(VideoPlaybackMode.external),

  // ─── عام ──────────────────────────────────────────────────
  iframe(VideoPlaybackMode.embed),
  directLink(VideoPlaybackMode.native);

  final VideoPlaybackMode mode;

  const VideoSourceType(this.mode);
}
