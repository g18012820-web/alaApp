import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/ui/app_colors.dart';
import '../constants/ui/app_text_styles.dart';

class CommonCircularPercentIndicator extends StatelessWidget {
  final double percent;
  final Color? progressColor;
  final double radius;
  final double lineWidth;
  final dynamic value;

  const CommonCircularPercentIndicator({
    super.key,
    required this.percent,
    this.progressColor,
    this.radius = 50.0,
    this.lineWidth = 10.0,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(radius * 2, radius * 2),
      painter: _CircularPainter(
        percent: percent,
        backgroundColor: AppColors.current.greyscale400,
        progressColor: progressColor ?? AppColors.current.success,
        lineWidth: lineWidth,
      ),
      child: Center(child: value is Widget ? value : Text(value, style: AppTextStyles.bodyMediumRegular)),
    );
  }
}

class _CircularPainter extends CustomPainter {
  final double percent;
  final Color backgroundColor;
  final Color progressColor;
  final double lineWidth;

  _CircularPainter({
    required this.percent,
    required this.backgroundColor,
    required this.progressColor,
    required this.lineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;
    final double arcAngle = 2 * math.pi * percent;

    final Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      arcAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
