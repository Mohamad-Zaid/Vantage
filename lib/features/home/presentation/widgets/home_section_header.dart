import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.titleKey,
    this.accentTitle = false,
  });

  final String titleKey;

  final bool accentTitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = accentTitle
        ? VantageColors.authPrimaryPurple
        : (isDark ? Colors.white : VantageColors.homeCategoryLabelLight);
    final seeAllColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titleKey.tr(),
          style: GoogleFonts.gabarito(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            LocaleKeys.home_seeAll.tr(),
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: seeAllColor,
            ),
          ),
        ),
      ],
    );
  }
}
