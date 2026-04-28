import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/generated/assets.dart';

class CartCouponRow extends StatelessWidget {
  const CartCouponRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final textC =
        isDark ? Colors.white70 : VantageColors.profileTextSecondaryLight;
    final purple = VantageColors.authPrimaryPurple;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(LocaleKeys.cart_couponComingSoon.tr())),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              SvgPicture.asset(Assets.vectorCartCoupon, width: 22, height: 22),
              const SizedBox(width: AppSpacing.inset10),
              Expanded(
                child: Text(
                  LocaleKeys.cart_couponHint.tr(),
                  style: GoogleFonts.nunitoSans(
                    color: textC,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Material(
                color: purple,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(LocaleKeys.cart_couponComingSoon.tr()),
                      ),
                    );
                  },
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.chevron_right_rounded, color: Colors.white, size: 20),
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
