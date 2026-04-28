import 'package:flutter/material.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';

class AddressDismissBackground extends StatelessWidget {
  const AddressDismissBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: AppSpacing.inset20),
      decoration: BoxDecoration(
        color: VantageColors.error.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Icon(
        Icons.delete_outline_rounded,
        color: Theme.of(context).colorScheme.onError,
      ),
    );
  }
}
