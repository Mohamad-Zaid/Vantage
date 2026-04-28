import 'package:flutter/material.dart';
import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/filter_option_tile.dart';
import 'package:vantage/core/widgets/filter_sheet_header.dart';
import 'package:vantage/features/search/domain/entities/search_filter.dart';

Future<GenderFilter?> showGenderBottomSheet(
    BuildContext context, GenderFilter? current) async {
  final result =
      await showModalBottomSheet<({GenderFilter? value, bool cleared})>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _GenderBottomSheet(current: current),
  );
  if (result == null) return current;
  if (result.cleared) return null;
  return result.value;
}

class _GenderBottomSheet extends StatelessWidget {
  const _GenderBottomSheet({required this.current});

  final GenderFilter? current;

  static const _options = [
    (value: GenderFilter.men, label: 'Men'),
    (value: GenderFilter.women, label: 'Women'),
    (value: GenderFilter.kids, label: 'Kids'),
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
                title: 'Gender',
                onClear: () => Navigator.pop(
                    context, (value: null as GenderFilter?, cleared: true)),
                onClose: () => Navigator.pop(context, null),
              ),
              const SizedBox(height: AppSpacing.xl),
              for (final opt in _options) ...[
                FilterOptionTile(
                  label: opt.label,
                  selected: current == opt.value,
                  onTap: () => Navigator.pop(
                    context,
                    (value: opt.value as GenderFilter?, cleared: false),
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
