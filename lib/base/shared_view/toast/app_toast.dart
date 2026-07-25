import 'package:flutter/material.dart';
import 'dart:async';

typedef AnimationControllerCallback = void Function(AnimationController);

enum DismissType { onSwipe, none }

enum ToastStatus {
  info('Notify', Colors.blue, Icon(Icons.info, color: Colors.white)),
  success('Successfully', Colors.green, Icon(Icons.info, color: Colors.white)),
  failure('Error', Colors.red, Icon(Icons.error, color: Colors.white));

  const ToastStatus(this.text, this.color, this.icon);
  final String text;
  final Color color;
  final dynamic icon;
}

class AppToast {
  static AppToast? _instance;

  AppToast._();

  factory AppToast.instance() => _instance ??= AppToast._();

  void failure(BuildContext context, String message) {
    return show(context, message, status: ToastStatus.failure);
  }

  void success(BuildContext context, String message) {
    return show(context, message, status: ToastStatus.success);
  }

  void show(
    BuildContext context,
    String message, {
    ToastStatus status = ToastStatus.info,
  }) {
    AnimationController? localAnimationController;

    _buildSnackBar(
      animationDuration: const Duration(milliseconds: 1000),
      reverseAnimationDuration: const Duration(milliseconds: 350),
      displayDuration: const Duration(milliseconds: 2000),
      onCreateAnimationController: (controller) => localAnimationController = controller,
      dismissType: DismissType.onSwipe,
      dismissDirection: [
        DismissDirection.horizontal,
        DismissDirection.vertical,
        DismissDirection.endToStart,
        DismissDirection.up,
        DismissDirection.startToEnd
      ],
      Overlay.of(context),
      CustomSnackBarWidget(
        onCloseClick: () => localAnimationController?.reverse(),
        message: message,
        status: status,
      ),
    );
  }

  void _buildSnackBar(
    OverlayState overlayState,
    Widget child, {
    Duration animationDuration = const Duration(milliseconds: 1200),
    Duration reverseAnimationDuration = const Duration(milliseconds: 550),
    Duration displayDuration = const Duration(milliseconds: 3000),
    VoidCallback? onTap,
    bool persistent = false,
    AnimationControllerCallback? onCreateAnimationController,
    EdgeInsets padding = const EdgeInsets.all(16),
    Curve curve = Curves.elasticOut,
    Curve reverseCurve = Curves.linearToEaseOut,
    DismissType dismissType = DismissType.onSwipe,
    List<DismissDirection> dismissDirection = const [DismissDirection.up],
  }) {
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (_) {
        return _TopSnackBar(
          onDismissed: () {
            overlayEntry.remove();
            _previousEntry = null;
          },
          animationDuration: animationDuration,
          reverseAnimationDuration: reverseAnimationDuration,
          displayDuration: displayDuration,
          onTap: onTap,
          persistent: persistent,
          onCreateAnimationController: onCreateAnimationController,
          padding: padding,
          curve: curve,
          reverseCurve: reverseCurve,
          dismissType: dismissType,
          dismissDirections: dismissDirection,
          child: child,
        );
      },
    );

    if (_previousEntry != null && _previousEntry!.mounted) {
      _previousEntry?.remove();
    }

    overlayState.insert(overlayEntry);
    _previousEntry = overlayEntry;
  }
}

class CustomSnackBarWidget extends StatefulWidget {
  final String message;
  final VoidCallback? onCloseClick;
  final Icon? icon;
  final BoxDecoration? iconWithDecoration;
  final ToastStatus status;

  const CustomSnackBarWidget({
    Key? key,
    required this.message,
    this.onCloseClick,
    this.icon,
    this.iconWithDecoration,
    this.status = ToastStatus.info,
  }) : super(key: key);

  @override
  CustomSnackBarWidgetState createState() => CustomSnackBarWidgetState();
}

class CustomSnackBarWidgetState extends State<CustomSnackBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        clipBehavior: Clip.hardEdge,
        constraints: const BoxConstraints(minHeight: 50),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(color: widget.status.color, borderRadius: const BorderRadius.all(Radius.circular(12))),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.status.icon != null) ...[
              if (widget.status.icon is Widget) widget.status.icon,
              const SizedBox(width: 5),
            ],
            Expanded(
              child: Text(widget.message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2),
            ),
          ],
        ),
      ),
    );
  }
}

OverlayEntry? _previousEntry;

class _TopSnackBar extends StatefulWidget {
  const _TopSnackBar({
    Key? key,
    required this.child,
    required this.onDismissed,
    required this.animationDuration,
    required this.reverseAnimationDuration,
    required this.displayDuration,
    required this.padding,
    required this.curve,
    required this.reverseCurve,
    required this.dismissDirections,
    this.onTap,
    this.persistent = false,
    this.onCreateAnimationController,
    this.dismissType = DismissType.onSwipe,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onDismissed;
  final Duration animationDuration;
  final Duration reverseAnimationDuration;
  final Duration displayDuration;
  final VoidCallback? onTap;
  final AnimationControllerCallback? onCreateAnimationController;
  final bool persistent;
  final EdgeInsets padding;
  final Curve curve;
  final Curve reverseCurve;
  final DismissType dismissType;
  final List<DismissDirection> dismissDirections;

  @override
  _TopSnackBarState createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<_TopSnackBar> with SingleTickerProviderStateMixin {
  late final Animation<Offset> _offsetAnimation;
  late final AnimationController _animationController;

  Timer? _timer;

  final _offsetTween = Tween(begin: const Offset(0, -1), end: Offset.zero);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: widget.reverseAnimationDuration,
    );
    _animationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed && !widget.persistent) {
          _timer = Timer(widget.displayDuration, () {
            if (mounted) {
              _animationController.reverse();
            }
          });
        }
        if (status == AnimationStatus.dismissed) {
          _timer?.cancel();
          widget.onDismissed.call();
        }
      },
    );

    widget.onCreateAnimationController?.call(_animationController);

    _offsetAnimation =
        _offsetTween.animate(CurvedAnimation(parent: _animationController, curve: widget.curve, reverseCurve: widget.reverseCurve));
    if (mounted) _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.padding.top,
      left: widget.padding.left,
      right: widget.padding.right,
      child: SlideTransition(position: _offsetAnimation, child: SafeArea(child: _buildDismissibleChild())),
    );
  }

  Widget _buildDismissibleChild() {
    switch (widget.dismissType) {
      case DismissType.onSwipe:
        var childWidget = widget.child;
        for (final direction in widget.dismissDirections) {
          childWidget = Dismissible(
            direction: direction,
            key: UniqueKey(),
            dismissThresholds: const {DismissDirection.up: 0.2},
            confirmDismiss: (direction) async {
              if (!widget.persistent && mounted) {
                if (direction == DismissDirection.down) {
                  await _animationController.reverse();
                } else {
                  _animationController.reset();
                }
              }
              return false;
            },
            child: childWidget,
          );
        }
        return childWidget;
      case DismissType.none:
        return widget.child;
    }
  }
}
