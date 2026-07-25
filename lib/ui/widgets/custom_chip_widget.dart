import 'package:flutter/material.dart';

import '../../base/constants/ui/app_colors.dart';
import '../../base/constants/ui/app_text_styles.dart';

class CustomChipWidget extends StatelessWidget {
  const CustomChipWidget({super.key, required this.label, this.selected = false, this.onSelected});

  final dynamic label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      onSelected: onSelected,
      label: label is Widget
          ? label
          : Text(
              label,
              style: AppTextStyles.bodyLargeSemiBold.withPrimaryColor(),
            ),
      labelStyle: AppTextStyles.bodyLargeSemiBold.copyWith(color: selected ? AppColors.current.otherWhite : AppColors.current.primary500),
      selected: selected,
      showCheckmark: false,
      selectedColor: AppColors.current.primary500,
      color: WidgetStateProperty.all(selected ? AppColors.current.primary500 : AppColors.current.otherWhite),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.current.primary500, width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
