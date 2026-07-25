import 'package:flutter/material.dart';

class CommonBottomNavigatorBarBackground extends StatelessWidget {
  const CommonBottomNavigatorBarBackground({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.visibleBorder = true,
  });

  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool visibleBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          border: visibleBorder ? Border(top: BorderSide(color: Colors.black.withOpacity(.1))) : null,
        ),
        child: SafeArea(
          minimum: padding ?? const EdgeInsets.only(bottom: 10).copyWith(top: 8),
          child: child,
        ));
  }
}
