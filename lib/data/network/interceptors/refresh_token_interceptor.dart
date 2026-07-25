import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc_template/base/constants/local/app_storage_keys.dart';
import 'package:flutter_bloc_template/base/constants/remote/http_header_constants.dart';
import 'package:injectable/injectable.dart';

import '../../../base/helper/checker.dart';
import '../../data_source/local/app_shared_preferences.dart';

@lazySingleton
class RefreshTokenInterceptor extends QueuedInterceptor {
  final AppSharedPreferences sharedPreferences;
  final Dio dio;

  RefreshTokenInterceptor(
      this.sharedPreferences,
      this.dio,
      );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await sharedPreferences.accessToken;
    if (!empty(token)) {
      options.headers[HttpHeaderConstants.authorization] = '${HttpHeaderConstants.bearer} $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isUnauthorized(err)) {
      return handler.next(err);
    }

    Future.delayed(const Duration(seconds: 5), () => super.onError(err, handler));
  }

  bool _isUnauthorized(DioException err) {
    return err.response?.statusCode == HttpStatus.unauthorized;
  }

  // Future<bool> _refreshToken() async {
  //   try {
  //     final refreshToken = sharedPreferences.getString(AppStorageKeys.refreshToken);
  //     if (refreshToken == null) return false;
  //
  //     final payload = TokenPayloadData(refreshToken: refreshToken);
  //     final response = await dio.post(Endpoints.REFRESH_TOKEN, data: payload.toJson());
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final data = response.data["data"];
  //       final newAccessToken = data["token"];
  //       final newRefreshToken = data["refreshToken"];
  //
  //       if (newAccessToken != null && newRefreshToken != null) {
  //         await _saveTokens(newAccessToken, newRefreshToken);
  //         return true;
  //       }
  //     }
  //   } catch (e) {
  //     // Log lỗi nếu cần thiết
  //     Log.e('Refresh token failed: $e');
  //   }
  //   return false;
  // }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      sharedPreferences.setString(AppStorageKeys.accessToken, accessToken),
      sharedPreferences.setString(AppStorageKeys.refreshToken, refreshToken),
    ]);
  }

  Future<void> _retryRequest(RequestOptions requestOptions, ErrorInterceptorHandler handler) async {
    try {
      final options = Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      );
      final response = await dio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );
      handler.resolve(response);
    } catch (e) {
      handler.reject(DioException(requestOptions: requestOptions, error: e));
    }
  }
}