import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_template/base/constants/ui/app_text_styles.dart';
import 'package:flutter_bloc_template/base/constants/ui/dimens.dart';
import 'package:flutter_bloc_template/base/shared_view/common_app_bar.dart';
import 'package:flutter_bloc_template/base/shared_view/common_button.dart';
import 'package:flutter_bloc_template/base/shared_view/common_scaffold.dart';
import 'package:flutter_bloc_template/navigation/router.gr.dart';
import 'package:flutter_bloc_template/ui/widgets/via_widget.dart';
import 'package:gap/gap.dart';

import '../../resource/generated/assets.gen.dart';
import '../../resource/generated/l10n.dart';
import '../widgets/auth_prompt_widget.dart';
import '../widgets/social_auth_provider/social_auth_provider_page.dart';

@RoutePage()
class LetInPage extends StatelessWidget {
  const LetInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
        appBar: CommonAppBar(),
        bottomNavigationBar: AuthPromptWidget(
          message: S.current.dont_have_an_account,
          actionText: S.current.sign_up,
          onActionTap: () => AutoRouter.of(context).push(const SignUpRoute()),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(6),
              AspectRatio(aspectRatio: 1.8, child: Assets.images.frame3.image(height: 200)),
              const Gap(30),
              Text(S.current.lets_you_in, style: AppTextStyles.h1Bold),
              const Gap(30),
              const SocialAuthProviderPage(),
              const Gap(Dimens.paddingVerticalLarge),
              ViaWidget(title: S.current.or.toLowerCase()),
              const Gap(Dimens.paddingVerticalLarge),
              CommonButton(
                onPressed: () {
                  AutoRouter.of(context).push(const LoginRoute());
                },
                title: S.current.sign_in_with_password,
                fullWidth: true,
              ),
            ],
          ),
        ));
  }
}
