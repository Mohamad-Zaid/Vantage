import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/filter_option_tile.dart';
import 'package:vantage/core/widgets/filter_sheet_header.dart';

class ProductDetailSizeSheet extends StatelessWidget {
  const ProductDetailSizeSheet({
    super.key,
    required this.sizes,
    required this.selected,
    required this.onSelect,
  });

  final List<String> sizes;
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? VantageColors.authBgDark1 : Colors.white;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilterSheetHeader(
                  title: LocaleKeys.productDetail_size.tr(),
                  showClear: false,
                  onClose: () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(height: 24),
                for (var i = 0; i < sizes.length; i++) ...[
                  if (i > 0) const SizedBox(height: 16),
                  FilterOptionTile(
                    label: sizes[i],
                    selected: sizes[i] == selected,
                    onTap: () {
                      onSelect(sizes[i]);
                      Navigator.of(context).maybePop();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
