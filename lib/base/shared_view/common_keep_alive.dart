import 'package:flutter/material.dart';

class CommonKeepAlive extends StatefulWidget {
  const CommonKeepAlive({super.key, required this.child});
  final Widget child;

  @override
  State<CommonKeepAlive> createState() => _CommonKeepAliveState();
}

class _CommonKeepAliveState extends State<CommonKeepAlive> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
