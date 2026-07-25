import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_template/base/helper/helper.dart';
import 'package:flutter_bloc_template/config/environment.dart';
import 'package:flutter_bloc_template/di/di.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final class DioClient implements LibraryInitializer<void> {
  DioClient() {
    init();
  }

  late Dio _dio;

  Dio get dio => _dio;

  @override
  Future<void> init() async {
    _dio = Dio()
      ..options = BaseOptions(
        baseUrl: SL.get<EnvironmentConfigurable>().getBaseUrl(),
        contentType: Headers.jsonContentType,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
      );
    if(!kReleaseMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
        enabled: kDebugMode,
      ));
    }
  }

  DioClient addInterceptors(List<Interceptor> interceptors) {
    _dio.interceptors.addAll(interceptors);
    return this;
  }

  DioClient setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    return this;
  }
}
