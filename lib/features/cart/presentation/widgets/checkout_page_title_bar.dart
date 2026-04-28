import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';

class CheckoutPageTitleBar extends StatelessWidget {
  const CheckoutPageTitleBar({
    super.key,
    required this.titleColor,
    required this.onBack,
  });

  final Color titleColor;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          VantageCircleBackButton(onPressed: onBack),
          Expanded(
            child: Text(
              LocaleKeys.cart_checkoutTitle.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.gabarito(
                color: titleColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.toolbarIconSlot),
        ],
      ),
    );
  }
}
