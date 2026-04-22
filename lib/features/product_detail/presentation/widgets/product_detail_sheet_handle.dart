import 'package:flutter/material.dart';

import 'package:vantage/core/theme/vantage_colors.dart';

class ProductDetailSheetDragHandle extends StatelessWidget {
  const ProductDetailSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        width: 134,
        height: 5,
        decoration: BoxDecoration(
          color: isDark ? Colors.white24 : VantageColors.homeCategoryLabelLight,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
