import 'dart:async';

import 'log.dart';

class EventDispatcher {
  static EventDispatcher? _singletonInstance;

  static EventDispatcher get instance {
    _singletonInstance ??= EventDispatcher();
    return _singletonInstance!;
  }

  final Map<String, StreamController> _map = {};

  void emit<T>(String eventName, T payload) {
    _map.putIfAbsent(eventName, () => StreamController.broadcast());
    CoreLog.d("Event Emitted: $eventName\r $payload");

    _map[eventName]!.add(payload);
  }

  StreamSubscription<dynamic> on(String eventName, Function(dynamic)? handler) {
    _map.putIfAbsent(eventName, () => StreamController.broadcast());
    return _map[eventName]!.stream.listen(handler);
  }
}
