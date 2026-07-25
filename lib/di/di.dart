import 'package:dio/dio.dart';
import 'package:flutter_bloc_template/data/network/dio_client.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/local/app_shared_preferences.dart';
import '../data/network/interceptors/access_token_interceptor.dart';
import '../data/network/interceptors/curl_interceptor.dart';
import '../data/network/interceptors/refresh_token_interceptor.dart';
import 'di.config.dart';

final SL = GetIt.instance..allowReassignment = true;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await _registerStorage();
  await _registerNetwork();
  SL.init();
  return;
}

Future<void> _registerNetwork() async {
  final client = DioClient();

  client.addInterceptors([
    RefreshTokenInterceptor(SL.get<AppSharedPreferences>(), client.dio),
    AccessTokenInterceptor(SL.get<AppSharedPreferences>()),
    CurlInterceptor(
      shouldLogOnSuccess: true,
      shouldConvertFormData: false,
    ),
    // RefreshTokenInterceptor(di.get<AppSharedPreferences>(), client.build()),
  ]);
  SL.registerSingleton<Dio>(client.dio);
}

Future<void> _registerStorage() async {
  final prefs = await SharedPreferences.getInstance();
  SL.registerSingleton<AppSharedPreferences>(AppSharedPreferences(prefs: prefs));
}
