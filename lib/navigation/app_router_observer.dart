import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/helper/log.dart';

class AppRouterObserver extends NavigatorObserver {
  void _log(String event, Route? route) {
    if (kDebugMode && route is! DialogRoute) {
      CoreLog.i("[$event]: ${route?.settings.name}");
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) => _log('Pop', route);

  @override
  void didPush(Route route, Route? previousRoute) => _log('Push', route);

  @override
  void didRemove(Route route, Route? previousRoute) => _log('Remove', route);

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => _log('Replace', newRoute);
}