import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/domain/entity/enum/enum.dart';
import 'package:collection/collection.dart';
import 'package:gap/gap.dart';

import '../../../base/constants/ui/app_colors.dart';
import '../../../resource/generated/l10n.dart';

class SocialAuthProviderPage extends StatelessWidget {
  const SocialAuthProviderPage({
    super.key,
    this.hideLabel = false,
  });

  final bool hideLabel;

  @override
  Widget build(BuildContext context) {
    if (hideLabel) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: _items(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: _items(),
    );
  }

  List<Widget> _items() {
    return SocialAuthProvider.values.mapIndexed<Widget>(
      (idx, e) {
        bool isLast = idx == SocialAuthProvider.values.length - 1;
        return Container(
          alignment: Alignment.center,
          margin: _margin(isLast),
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: hideLabel ? 30 : Dimens.paddingHorizontal),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.current.greyscale200)),
          child: _child(e),
        );
      },
    ).toList();
  }

  Widget _child(SocialAuthProvider e) {
    if (hideLabel) return e.fromWidget();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        e.fromWidget(),
        const Gap(12),
        Text(S.current.continue_with(e.fromTitle()), style: AppTextStyles.bodyLargeSemiBold),
      ],
    );
  }

  EdgeInsets _margin(bool isLast) {
    if (hideLabel) {
      return isLast ? EdgeInsets.zero : const EdgeInsets.only(right: Dimens.paddingHorizontal);
    }
    return isLast ? EdgeInsets.zero : const EdgeInsets.only(bottom: Dimens.paddingVertical);
  }
}
