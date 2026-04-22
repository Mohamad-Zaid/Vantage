import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vantage/core/catalog/shop_categories_catalog.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';
import 'package:vantage/router/app_router.dart';

@RoutePage()
class ShopByCategoriesPage extends StatelessWidget {
  const ShopByCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : VantageColors.homeCategoryLabelLight;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VantageCircleBackButton(
                onPressed: () => context.router.maybePop(),
              ),
              const SizedBox(height: 16),
              Text(
                LocaleKeys.categories_shopByTitle.tr(),
                style: GoogleFonts.gabarito(
                  color: titleColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 19),
              Expanded(
                child: ListView.separated(
                  itemCount: kShopCategoryCatalog.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = kShopCategoryCatalog[index];
                    return _ShopCategoryListTile(
                      title: item.titleKey.tr(),
                      assetPath: item.assetPath,
                      onTap: () => context.router.push(
                        CategoryDetailRoute(categoryId: item.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShopCategoryListTile extends StatelessWidget {
  const _ShopCategoryListTile({
    required this.title,
    required this.assetPath,
    required this.onTap,
  });

  final String title;
  final String assetPath;
  final VoidCallback onTap;

  static const double _rowHeight = 64;
  static const double _avatar = 40;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? VantageColors.authBgDark2 : VantageColors.homeAudiencePillLight;
    final textColor = isDark ? Colors.white : VantageColors.homeCategoryLabelLight;

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: _rowHeight,
          child: Row(
            children: [
              const SizedBox(width: 12),
              Container(
                width: _avatar,
                height: _avatar,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(assetPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.nunitoSans(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
