import 'package:auto_route/auto_route.dart';
import 'package:vantage/router/app_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'package:vantage/core/catalog/shop_categories_catalog.dart';
import 'package:vantage/core/theme/app_spacing.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/translations/locale_keys.g.dart';
import 'package:vantage/core/widgets/vantage_circle_back_button.dart';
import 'package:vantage/core/widgets/vantage_product_card.dart';
import 'package:vantage/di/injection.dart';
import 'package:vantage/features/categories/presentation/cubit/category_products_cubit.dart';
import 'package:vantage/features/categories/presentation/cubit/category_products_state.dart';
import 'package:vantage/features/wishlist/presentation/cubit/favorites_cubit.dart';
import 'package:vantage/features/wishlist/presentation/cubit/favorites_state.dart';

@RoutePage()
class CategoryDetailPage extends StatefulWidget {
  const CategoryDetailPage({
    super.key,
    required this.categoryId,
  });

  final String categoryId;

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  late final CategoryProductsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<CategoryProductsCubit>()..load(widget.categoryId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : VantageColors.homeCategoryLabelLight;
    final titleKey = categoryTitleKeyForId(widget.categoryId);
    final categoryName =
        titleKey != null ? titleKey.tr() : widget.categoryId;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VantageCircleBackButton(
                  onPressed: () => context.router.maybePop(),
                ),
                const SizedBox(height: AppSpacing.lg),
                BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
                  builder: (context, state) {
                    final subtitle = switch (state) {
                      CategoryProductsLoaded(:final products) =>
                        ' (${products.length})',
                      CategoryProductsLoading() => ' (…)',
                      CategoryProductsInitial() => ' (…)',
                      _ => '',
                    };
                    return Text(
                      '$categoryName$subtitle',
                      style: GoogleFonts.gabarito(
                        color: titleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child:
                      BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
                    builder: (context, state) {
                      return switch (state) {
                        CategoryProductsInitial() =>
                          const _CategoryGridShimmer(),
                        CategoryProductsLoading() =>
                          const _CategoryGridShimmer(),
                        CategoryProductsError(:final message) => Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${LocaleKeys.common_error.tr()}\n$message',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: titleColor),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                TextButton(
                                  onPressed: () => _cubit.load(widget.categoryId),
                                  child: Text(LocaleKeys.common_retry.tr()),
                                ),
                              ],
                            ),
                          ),
                        CategoryProductsLoaded(:final products) =>
                          products.isEmpty
                              ? Center(
                                  child: Text(
                                    LocaleKeys.home_emptyProducts.tr(),
                                    style: TextStyle(color: titleColor),
                                  ),
                                )
                              : BlocBuilder<FavoritesCubit, FavoritesState>(
                                  buildWhen: (p, c) =>
                                      c is FavoritesLoaded ||
                                      c is FavoritesLoading ||
                                      c is FavoritesInitial,
                                  builder: (context, favState) {
                                    final ids = favState is FavoritesLoaded
                                        ? favState.ids
                                        : <String>{};
                                    return GridView.builder(
                                      padding:
                                          const EdgeInsets.only(bottom: 5),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        mainAxisExtent: VantageProductCard
                                            .gridMainAxisExtent,
                                      ),
                                      itemCount: products.length,
                                      itemBuilder: (context, i) {
                                        final product = products[i];
                                        return Align(
                                          alignment: Alignment.topCenter,
                                          child: VantageProductCard(
                                            product: product,
                                            onTap: () => context.router.push(
                                              ProductDetailRoute(
                                                product: product,
                                              ),
                                            ),
                                            isFavorite:
                                                ids.contains(product.id),
                                            onFavoriteTap: () => context
                                                .read<FavoritesCubit>()
                                                .toggleFavorite(product),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                      };
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryGridShimmer extends StatelessWidget {
  const _CategoryGridShimmer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.grey.shade800 : Colors.grey.shade400;
    final highlight = isDark ? Colors.grey.shade600 : Colors.grey.shade200;
    final fill = Theme.of(context).colorScheme.surfaceContainerHighest;

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 5),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: VantageProductCard.gridMainAxisExtent,
      ),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
