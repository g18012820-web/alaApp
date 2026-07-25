import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:gap/gap.dart';

import '../../resource/generated/assets.gen.dart';

class CommonCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CommonCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool enable = value;
    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatefulBuilder(
            builder: (_, setState) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    enable = !enable;
                  });
                },
                child: enable ? Assets.icons.checkboxChecked.svg() : Assets.icons.checkboxUnchecked.svg(),
              );
            },
          ),
          const Gap(12),
          Text(label, style: AppTextStyles.bodyMediumSemiBold),
        ],
      ),
    );
  }
}
