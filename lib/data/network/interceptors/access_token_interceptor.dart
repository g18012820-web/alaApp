
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../base/constants/remote/http_header_constants.dart';
import '../../../base/helper/checker.dart';
import '../../data_source/local/app_shared_preferences.dart';


@lazySingleton
class AccessTokenInterceptor extends InterceptorsWrapper {
  final AppSharedPreferences _sharedPreferences;

  AccessTokenInterceptor(this._sharedPreferences);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _sharedPreferences.accessToken;
    if (!empty(token)) {
      options.headers[HttpHeaderConstants.authorization] = '${HttpHeaderConstants.bearer} $token';
    }
    super.onRequest(options, handler);
  }
}