import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/filter_sheet_header.dart';
import 'package:vantage/features/product_detail/presentation/product_detail_color_locale.dart';
import 'package:vantage/features/product_detail/presentation/product_detail_color_options.dart';

Color _unselectedSwatchBorder(Color swatch, bool isDark) {
  if (!isDark) {
    return swatch == VantageColors.homeCategoryLabelLight
        ? const Color(0xFFE0E0E0)
        : Colors.transparent;
  }
  return swatch == VantageColors.homeCategoryLabelLight
      ? Colors.white54
      : Colors.transparent;
}

class ProductDetailColorSheet extends StatelessWidget {
  const ProductDetailColorSheet({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;
    final primary = scheme.primary;
    final onPrimary = scheme.onPrimary;
    final sheetBg = isDark ? VantageColors.authBgDark1 : Colors.white;
    final titleColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final unselectedCard = isDark
        ? VantageColors.authBgDark2
        : VantageColors.homeAudiencePillLight;
    final options = ProductDetailColorOptions.options;

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
                  title: LocaleKeys.productDetail_color.tr(),
                  showClear: false,
                  onClose: () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(height: AppSpacing.xl),
                for (var i = 0; i < options.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.lg),
                  _ColorOptionRow(
                    label: trProductDetailColorName(options[i].localeSuffix),
                    swatch: options[i].swatch,
                    selected: i == selectedIndex,
                    isDark: isDark,
                    primary: primary,
                    onPrimary: onPrimary,
                    unselectedCard: unselectedCard,
                    titleColor: titleColor,
                    onTap: () {
                      onSelect(i);
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

class _ColorOptionRow extends StatelessWidget {
  const _ColorOptionRow({
    required this.label,
    required this.swatch,
    required this.selected,
    required this.isDark,
    required this.primary,
    required this.onPrimary,
    required this.unselectedCard,
    required this.titleColor,
    required this.onTap,
  });

  final String label;
  final Color swatch;
  final bool selected;
  final bool isDark;
  final Color primary;
  final Color onPrimary;
  final Color unselectedCard;
  final Color titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? primary : unselectedCard;
    final fg = selected ? onPrimary : titleColor;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunitoSans(
                      color: fg,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                ),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: swatch,
                    border: Border.all(
                      width: selected ? 3 : 1.5,
                      color: selected
                          ? onPrimary
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.35)
                              : _unselectedSwatchBorder(swatch, isDark)),
                    ),
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Icon(Icons.check_rounded, color: onPrimary, size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
