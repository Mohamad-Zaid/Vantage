import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vantage/core/theme/vantage_colors.dart';

class FilterOptionTile extends StatelessWidget {
  const FilterOptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.maxLines = 1,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;
    final primary = scheme.primary;
    final onPrimary = scheme.onPrimary;

    final unselectedCard = isDark
        ? VantageColors.authBgDark2
        : VantageColors.homeAudiencePillLight;

    final bg = selected ? primary : unselectedCard;
    final textColor = selected
        ? onPrimary
        : (isDark ? Colors.white : VantageColors.homeCategoryLabelLight);
    final checkColor = selected ? onPrimary : textColor;

    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Container(
          width: double.infinity,
          padding: maxLines == 1
              ? const EdgeInsets.symmetric(horizontal: 18)
              : const EdgeInsets.fromLTRB(18, 12, 18, 12),
          decoration: ShapeDecoration(
            color: bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunitoSans(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (selected) ...[
                Icon(Icons.check_rounded, color: checkColor, size: 20),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
