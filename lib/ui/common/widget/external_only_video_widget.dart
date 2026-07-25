import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// بعض خدمات التخزين (MEGA، Terabox، pCloud) لا توفّر تضمينًا رسميًا موثوقًا
/// (روابطها مشفّرة من طرف العميل أو مؤقتة الصلاحية)، لذلك تُفتح في المتصفح
/// الخارجي بدل تضمينها داخل التطبيق. هذا سلوك مقصود وليس نقصًا في التنفيذ.
class ExternalOnlyVideoWidget extends StatelessWidget {
  final String url;

  const ExternalOnlyVideoWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.open_in_new, color: Colors.white, size: 32),
              const SizedBox(height: 12),
              const Text('هذا المصدر لا يدعم العرض داخل التطبيق', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.current.primary500),
                onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
                child: const Text('فتح خارجيًا'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
