import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_loading_indicator.dart';
import 'package:vantage/features/auth/presentation/sign_in_page_dimens.dart';

class SignInSubmitButton extends StatelessWidget {
  const SignInSubmitButton({
    super.key,
    required this.buttonKey,
    required this.isLoading,
    required this.onContinue,
  });

  final GlobalKey buttonKey;
  final bool isLoading;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SignInPageDimens.fieldHeight,
      child: FilledButton(
        key: buttonKey,
        onPressed: isLoading ? null : onContinue,
        style: FilledButton.styleFrom(
          backgroundColor: VantageColors.authPrimaryPurple,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              VantageColors.authPrimaryPurple.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SignInPageDimens.buttonHorizontalPadding,
            vertical: SignInPageDimens.buttonVerticalPadding,
          ),
          textStyle: const TextStyle(
            fontSize: SignInPageDimens.subtitleFontSize,
            fontWeight: FontWeight.w500,
            height: 1.67,
            letterSpacing: -0.5,
          ),
        ),
        child: isLoading
            ? const VantageLoadingIndicator.onPrimary()
            : Text(LocaleKeys.auth_continue.tr()),
      ),
    );
  }
}
