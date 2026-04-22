import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';

import 'package:vantage/features/auth/presentation/sign_in_page_dimens.dart';

class SignInGoogleButton extends StatelessWidget {
  const SignInGoogleButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SignInPageDimens.fieldHeight,
      child: Material(
        color: VantageColors.authBgDark2,
        borderRadius: BorderRadius.circular(100),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                LocaleKeys.auth_continueWithGoogle.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.67,
                  letterSpacing: -0.5,
                ),
              ),
              Positioned(
                left: 17.42,
                top: 0,
                bottom: 0,
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CachedNetworkImage(
                      imageUrl: 'https://www.google.com/favicon.ico',
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.g_mobiledata,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
