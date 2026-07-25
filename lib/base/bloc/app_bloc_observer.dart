import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      log('📦 [BLoC CREATED]: ${bloc.runtimeType} has been initialized');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      log('🔴 [BLoC ERROR]: An error occurred in ${bloc.runtimeType}. Error: $error');
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      log('🕊 [BLoC CLOSED]: ${bloc.runtimeType} has been disposed');
    }
  }
}
