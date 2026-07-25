import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';

class DotWidget extends StatelessWidget {
  const DotWidget({
    super.key,
    required this.index,
    required this.total,
    this.selectedColor,
    this.unSelectedColor,
  });

  final int index;
  final int total;
  final Color? selectedColor;
  final Color? unSelectedColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List<Widget>.generate(
        total,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: i == index ? 32 : 8,
          height: 8,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: i == index ? (selectedColor ?? AppColors.current.primary500) : (unSelectedColor ?? AppColors.current.greyscale300),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ).toList(),
    );
  }
}
