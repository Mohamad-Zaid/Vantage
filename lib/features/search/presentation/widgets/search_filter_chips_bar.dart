import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/features/search/domain/entities/search_filter.dart';
import 'package:vantage/generated/assets.dart';
import 'deals_bottom_sheet.dart';
import 'gender_bottom_sheet.dart';
import 'price_bottom_sheet.dart';
import 'sort_bottom_sheet.dart';

class SearchFilterChipsBar extends StatelessWidget {
  const SearchFilterChipsBar({
    super.key,
    required this.filter,
    required this.onFilterChanged,
  });

  final SearchFilter filter;
  final ValueChanged<SearchFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final count = filter.activeCount;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _FilterChip(
            isDark: isDark,
            active: count > 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  Assets.vectorFilterApplied,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  '$count',
                  style: _chipTextStyle(active: true),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),

          _FilterChip(
            isDark: isDark,
            active: filter.deal != null,
            onTap: () async {
              final result =
                  await showDealsBottomSheet(context, filter.deal);
              if (!context.mounted) return;
              onFilterChanged(filter.copyWith(deal: result));
            },
            child: Text(
              _dealLabel(filter.deal),
              style: _chipTextStyle(active: filter.deal != null),
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),

          _FilterChip(
            isDark: isDark,
            active: filter.minPrice != null || filter.maxPrice != null,
            onTap: () async {
              final result = await showPriceBottomSheet(
                context,
                (min: filter.minPrice, max: filter.maxPrice),
              );
              if (!context.mounted) return;
              if (result != null) {
                onFilterChanged(filter.copyWith(
                  minPrice: result.min,
                  maxPrice: result.max,
                ));
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Price',
                  style: _chipTextStyle(
                      active: filter.minPrice != null ||
                          filter.maxPrice != null),
                ),
                const SizedBox(width: AppSpacing.xxs),
                SvgPicture.asset(
                  Assets.vectorArrowDown,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    (filter.minPrice != null || filter.maxPrice != null)
                        ? Colors.white
                        : (isDark
                            ? Colors.white
                            : VantageColors.homeCategoryLabelLight),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),

          _FilterChip(
            isDark: isDark,
            active: filter.sortBy != SortBy.recommended,
            onTap: () async {
              final result =
                  await showSortBottomSheet(context, filter.sortBy);
              if (!context.mounted) return;
              onFilterChanged(
                  filter.copyWith(sortBy: result ?? SortBy.recommended));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sort by',
                  style: _chipTextStyle(
                      active: filter.sortBy != SortBy.recommended),
                ),
                const SizedBox(width: AppSpacing.xxs),
                SvgPicture.asset(
                  Assets.vectorArrowDown,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    filter.sortBy != SortBy.recommended
                        ? Colors.white
                        : (isDark
                            ? Colors.white
                            : VantageColors.homeCategoryLabelLight),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),

          _FilterChip(
            isDark: isDark,
            active: filter.gender != null,
            onTap: () async {
              final result =
                  await showGenderBottomSheet(context, filter.gender);
              if (!context.mounted) return;
              onFilterChanged(filter.copyWith(gender: result));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _genderLabel(filter.gender),
                  style: _chipTextStyle(active: filter.gender != null),
                ),
                const SizedBox(width: AppSpacing.xxs),
                SvgPicture.asset(
                  Assets.vectorArrowDown,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    filter.gender != null
                        ? Colors.white
                        : (isDark
                            ? Colors.white
                            : VantageColors.homeCategoryLabelLight),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _dealLabel(DealFilter? deal) => switch (deal) {
        DealFilter.onSale => 'On Sale',
        DealFilter.freeShipping => 'Free Shipping',
        null => 'On Sale',
      };

  String _genderLabel(GenderFilter? gender) => switch (gender) {
        GenderFilter.men => 'Men',
        GenderFilter.women => 'Women',
        GenderFilter.kids => 'Kids',
        null => 'Men',
      };

  TextStyle _chipTextStyle({required bool active}) => GoogleFonts.nunitoSans(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.isDark,
    required this.active,
    required this.child,
    this.onTap,
  });

  final bool isDark;
  final bool active;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = active
        ? VantageColors.authPrimaryPurple
        : (isDark
            ? VantageColors.authBgDark2
            : VantageColors.homeAudiencePillLight);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: ShapeDecoration(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: DefaultTextStyle(
          style: GoogleFonts.nunitoSans(
            color: active
                ? Colors.white
                : (isDark
                    ? Colors.white
                    : VantageColors.homeCategoryLabelLight),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.6,
          ),
          child: child,
        ),
      ),
    );
  }
}
