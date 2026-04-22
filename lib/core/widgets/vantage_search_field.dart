import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/generated/assets.dart';

class VantageSearchField extends StatelessWidget {
  const VantageSearchField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark
        ? VantageColors.authBgDark2
        : VantageColors.homeSearchFieldLight;
    final foreground =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final iconColor = foreground;
    final hintColor =
        isDark ? foreground : foreground.withValues(alpha: 0.55);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide.none,
    );

    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        cursorColor: VantageColors.authPrimaryPurple,
        style: GoogleFonts.nunitoSans(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: fillColor,
          hoverColor: Colors.transparent,
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          disabledBorder: border,
          errorBorder: border,
          focusedErrorBorder: border,
          contentPadding: const EdgeInsets.only(left: 4, right: 19),
          hintText: LocaleKeys.home_search.tr(),
          hintStyle: GoogleFonts.nunitoSans(
            color: hintColor,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.6,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 11),
            child: SvgPicture.asset(
              Assets.vectorHomeSearch,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 42,
            minHeight: 40,
          ),
        ),
      ),
    );
  }
}
