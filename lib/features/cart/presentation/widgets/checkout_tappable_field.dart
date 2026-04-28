import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';

class CheckoutTappableField extends StatelessWidget {
  const CheckoutTappableField({
    super.key,
    required this.label,
    required this.valueText,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final String valueText;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark
        ? VantageColors.authBgDark2
        : VantageColors.homeAudiencePillLight;
    final titleC =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final subC = isDark
        ? Colors.white70
        : VantageColors.profileTextSecondaryLight;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.nunitoSans(
                        color: subC,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      valueText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        color: titleC,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    color: titleC.withValues(alpha: 0.5),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
