import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/generated/assets.dart';
import 'package:vantage/router/app_router.dart';

class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key});

  static const List<({String id, String labelKey, String asset})> _items = [
    (id: 'cat_hoodies', labelKey: LocaleKeys.home_categoryHoodies, asset: Assets.categoryHoodies),
    (id: 'cat_shorts', labelKey: LocaleKeys.home_categoryShorts, asset: Assets.categoryShorts),
    (id: 'cat_shoes', labelKey: LocaleKeys.home_categoryShoes, asset: Assets.categoryShoes),
    (id: 'cat_bags', labelKey: LocaleKeys.home_categoryBag, asset: Assets.categoryBag),
    (
      id: 'cat_accessories',
      labelKey: LocaleKeys.home_categoryAccessories,
      asset: Assets.categoryAccessories,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerColor = isDark
        ? Colors.white
        : VantageColors.homeCategoryLabelLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.home_categories.tr(),
              style: GoogleFonts.gabarito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: headerColor,
              ),
            ),
            GestureDetector(
              onTap: () => context.router.push(const ShopByCategoriesRoute()),
              child: Text(
                LocaleKeys.home_seeAll.tr(),
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: headerColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final item in _items)
              Expanded(
                child: HomeCategoryChip(
                  label: item.labelKey.tr(),
                  assetPath: item.asset,
                  onTap: () => context.router.push(
                    CategoryDetailRoute(categoryId: item.id),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class HomeCategoryChip extends StatelessWidget {
  const HomeCategoryChip({
    super.key,
    required this.label,
    required this.assetPath,
    required this.onTap,
  });

  final String label;
  final String assetPath;
  final VoidCallback onTap;

  static const double _circle = 56;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? Colors.white
        : VantageColors.homeCategoryLabelLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: _circle,
              height: _circle,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: AssetImage(assetPath),
                  fit: BoxFit.cover,
                ),
                shape: const OvalBorder(),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(
                  color: labelColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
