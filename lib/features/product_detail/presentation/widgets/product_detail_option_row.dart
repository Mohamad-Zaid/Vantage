import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';

class ProductDetailOptionRow extends StatelessWidget {
  const ProductDetailOptionRow({
    super.key,
    required this.label,
    required this.onTap,
    required this.trailing,
  });

  final String label;
  final VoidCallback onTap;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final labelColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(100),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunitoSans(
                    color: labelColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                  ),
                ),
                const Spacer(),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
