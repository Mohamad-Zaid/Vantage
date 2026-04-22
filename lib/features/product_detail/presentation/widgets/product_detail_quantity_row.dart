import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';

class ProductDetailQuantityRow extends StatelessWidget {
  const ProductDetailQuantityRow({
    super.key,
    required this.label,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String label;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final labelColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final purple = VantageColors.authPrimaryPurple;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(100),
      clipBehavior: Clip.antiAlias,
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
              Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RoundIconButton(
                      backgroundColor: purple,
                      icon: Icons.remove_rounded,
                      onPressed: onDecrement,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '$quantity',
                        style: GoogleFonts.nunitoSans(
                          color: labelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                    ),
                    _RoundIconButton(
                      backgroundColor: purple,
                      icon: Icons.add_rounded,
                      onPressed: onIncrement,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.backgroundColor,
    required this.icon,
    required this.onPressed,
  });

  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
