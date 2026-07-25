import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/extension/context_extension.dart';

import '../constants/ui/app_colors.dart';

class CommonScaffold extends StatelessWidget {
  const CommonScaffold({
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
    this.backgroundColor,
    this.hideKeyboardWhenTouchOutside = true,
    this.preventSwipeBack = false,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    super.key,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool hideKeyboardWhenTouchOutside;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool preventSwipeBack;
  final bool extendBody;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    Widget scaffold = _buildScaffold();
    scaffold = _wrapWithPopScope(scaffold);
    return hideKeyboardWhenTouchOutside ? GestureDetector(onTap: context.hideKeyboard, child: scaffold) : scaffold;
  }

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.current.otherWhite,
      body: body,
      appBar: appBar,
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
    );
  }

  Widget _wrapWithPopScope(Widget child) {
    if (!preventSwipeBack) return child;
    return PopScope(
      child: child,
      onPopInvokedWithResult: (_, __) async {},
    );
  }
}