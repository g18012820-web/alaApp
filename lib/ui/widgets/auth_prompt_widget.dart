import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_colors.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';

class AuthPromptWidget extends StatelessWidget {
  final String message;
  final String actionText;
  final VoidCallback onActionTap;

  const AuthPromptWidget({
    super.key,
    required this.message,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.current.greyscale500),
          children: [
            TextSpan(text: '$message '),
            TextSpan(
              text: actionText,
              style: AppTextStyles.bodyMediumSemiBold.copyWith(color: AppColors.current.primary500),
              recognizer: TapGestureRecognizer()..onTap = onActionTap,
            ),
          ],
        ),
      ),
    );
  }
}
