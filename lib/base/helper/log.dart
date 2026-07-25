import 'package:logger/logger.dart';

abstract final class CoreLog {
  const CoreLog._();

  static bool enableLog = true;

  static Function(Level, String)? onPrintLog;

  static Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  static void d(
    Object? message, {
    String? name,
    DateTime? time,
  }) {
    print('enableLog--------> $message');
    if (!enableLog) return;
    logger.d("${DateTime.now().toString()}\n$message");
  }

  static void e(Object? errorMessage) {
    if (!enableLog) return;
    logger.d('💢 $errorMessage');
  }

  static void i(String message) {
    if (!enableLog) return;
    if (onPrintLog == null) {
      logger.i("${DateTime.now().toString()}\n$message");
    }
  }
}
