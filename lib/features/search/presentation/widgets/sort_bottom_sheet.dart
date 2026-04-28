import 'package:flutter/material.dart';
import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/filter_option_tile.dart';
import 'package:vantage/core/widgets/filter_sheet_header.dart';
import 'package:vantage/features/search/domain/entities/search_filter.dart';

Future<SortBy?> showSortBottomSheet(
    BuildContext context, SortBy current) async {
  final result = await showModalBottomSheet<({SortBy? value, bool cleared})>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _SortBottomSheet(current: current),
  );
  if (result == null) return current;
  if (result.cleared) return null;
  return result.value;
}

class _SortBottomSheet extends StatelessWidget {
  const _SortBottomSheet({required this.current});

  final SortBy current;

  static const _options = [
    (value: SortBy.recommended, label: 'Recommended'),
    (value: SortBy.newest, label: 'Newest'),
    (value: SortBy.lowestHighest, label: 'Lowest - Highest Price'),
    (value: SortBy.highestLowest, label: 'Highest - Lowest Price'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? VantageColors.authBgDark1 : Colors.white;

    return Container(
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
                title: 'Sort by',
                onClear: () => Navigator.pop(
                    context, (value: null, cleared: true)),
                onClose: () => Navigator.pop(context, null),
              ),
              const SizedBox(height: AppSpacing.xl),
              for (final opt in _options) ...[
                FilterOptionTile(
                  label: opt.label,
                  selected: current == opt.value,
                  onTap: () => Navigator.pop(
                    context,
                    (value: opt.value as SortBy?, cleared: false),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
