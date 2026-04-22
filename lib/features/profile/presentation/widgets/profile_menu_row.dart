import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/directional_arrow_icon.dart';

class ProfileMenuRow extends StatelessWidget {
  const ProfileMenuRow({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg =
        isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final titleColor = isDark ? Colors.white : VantageColors.homeCategoryLabelLight;

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 16, end: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: const FontWeight(450),
                      color: titleColor,
                    ),
                  ),
                ),
                DirectionalArrowIcon(color: titleColor, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
