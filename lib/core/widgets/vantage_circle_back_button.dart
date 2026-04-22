import 'package:flutter/material.dart';

import 'package:vantage/core/theme/vantage_colors.dart';

class VantageCircleBackButton extends StatelessWidget {
  const VantageCircleBackButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final iconColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;

    return Material(
      color: bg,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            Icons.chevron_left_rounded,
            size: 28,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
