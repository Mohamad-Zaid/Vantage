import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';

import '../../domain/entities/order_status_filter.dart';

class OrdersFilterChips extends StatelessWidget {
  const OrdersFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final OrderStatusFilter selected;
  final ValueChanged<OrderStatusFilter> onSelected;

  static String _label(OrderStatusFilter f) => switch (f) {
    OrderStatusFilter.processing => LocaleKeys.orders_filterProcessing.tr(),
    OrderStatusFilter.shipped => LocaleKeys.orders_filterShipped.tr(),
    OrderStatusFilter.delivered => LocaleKeys.orders_filterDelivered.tr(),
    OrderStatusFilter.returned => LocaleKeys.orders_filterReturned.tr(),
    OrderStatusFilter.canceled => LocaleKeys.orders_filterCanceled.tr(),
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveBg = isDark
        ? VantageColors.authBgDark2
        : VantageColors.homeAudiencePillLight;
    final inactiveFg = isDark
        ? Colors.white
        : VantageColors.homeCategoryLabelLight;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var i = 0; i < OrderStatusFilter.values.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.inset13),
            _FilterChip(
              label: _label(OrderStatusFilter.values[i]),
              selected: OrderStatusFilter.values[i] == selected,
              selectedBg: VantageColors.authPrimaryPurple,
              unselectedBg: inactiveBg,
              selectedFg: Colors.white,
              unselectedFg: inactiveFg,
              onTap: () => onSelected(OrderStatusFilter.values[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.selectedBg,
    required this.unselectedBg,
    required this.selectedFg,
    required this.unselectedFg,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedBg;
  final Color unselectedBg;
  final Color selectedFg;
  final Color unselectedFg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? selectedBg : unselectedBg,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            label,
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
            style: GoogleFonts.nunitoSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.6,
              color: selected ? selectedFg : unselectedFg,
            ),
          ),
        ),
      ),
    );
  }
}
