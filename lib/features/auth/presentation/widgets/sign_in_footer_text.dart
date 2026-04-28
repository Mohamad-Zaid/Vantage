import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/features/auth/presentation/sign_in_page_dimens.dart';
import 'package:vantage/router/app_router.dart';

class SignInFooterText extends StatelessWidget {
  const SignInFooterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.auth_noAccount.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: SignInPageDimens.captionFontSize,
            fontWeight: FontWeight.w400,
            letterSpacing: SignInPageDimens.titleLetterSpacing,
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        GestureDetector(
          onTap: () => context.router.push(const CreateAccountRoute()),
          child: Text(
            LocaleKeys.auth_createOne.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: SignInPageDimens.captionFontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: SignInPageDimens.titleLetterSpacing,
            ),
          ),
        ),
      ],
    );
  }
}
