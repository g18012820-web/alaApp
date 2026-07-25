import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// مشغّل بالتضمين (Embed): يعرض رابط iframe الرسمي للمنصة داخل WebView.
/// يُستخدم لمنصات لا توفّر رابط تشغيل مباشر (يوتيوب، فيميو، ديلي موشن،
/// فيسبوك، انستغرام، تيك توك، تويتش، لووم، ويستيا، برايتكوف، JW Player،
/// SproutVideo، تيليجرام، Google Drive، Dropbox، OneDrive، Box).
class EmbedVideoPlayerWidget extends StatefulWidget {
  final String embedUrl;

  const EmbedVideoPlayerWidget({super.key, required this.embedUrl});

  @override
  State<EmbedVideoPlayerWidget> createState() => _EmbedVideoPlayerWidgetState();
}

class _EmbedVideoPlayerWidgetState extends State<EmbedVideoPlayerWidget> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.embedUrl));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        alignment: Alignment.center,
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const CircularProgressIndicator(color: Colors.white),
        ],
      ),
    );
  }
}
