import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vantage/core/theme/vantage_colors.dart';

class FilterSheetHeader extends StatelessWidget {
  const FilterSheetHeader({
    super.key,
    required this.title,
    required this.onClose,
    this.onClear,
    this.showClear = true,
  }) : assert(!showClear || onClear != null, 'onClear is required when showClear is true');

  final String title;
  final VoidCallback onClose;
  final VoidCallback? onClear;
  final bool showClear;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;

    return Stack(
      alignment: Alignment.center,
      children: [
        if (showClear && onClear != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: GestureDetector(
              onTap: onClear,
              child: Text(
                'Clear',
                style: GoogleFonts.nunitoSans(
                  color: titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        else
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: SizedBox(width: 40),
          ),
        Text(
          title,
          style: GoogleFonts.gabarito(
            color: titleColor,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: GestureDetector(
            onTap: onClose,
            child: Icon(Icons.close, color: titleColor, size: 24),
          ),
        ),
      ],
    );
  }
}
