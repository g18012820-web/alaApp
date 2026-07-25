import 'package:flutter/cupertino.dart';

extension ContextExtension on BuildContext {
  void hideKeyboard() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) FocusManager.instance.primaryFocus?.unfocus();
  }
}
