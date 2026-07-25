class AppException implements Exception {
  final String message;
  final int? statusCode;
  final AppExceptionType type;

  AppException(this.message, {this.statusCode, required this.type});

  @override
  String toString() => 'AppException: $message (Type: $type, Status Code: $statusCode)';
}

enum AppExceptionType {
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badResponse,
  cancel,
  connectionError,
  unknown,
  unauthorized,
  other
}