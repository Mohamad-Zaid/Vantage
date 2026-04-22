import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantage/router/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vantage/core/domain/entities/product_entity.dart';
import 'package:vantage/core/theme/vantage_colors.dart';
import 'package:vantage/core/widgets/vantage_product_card.dart';
import 'package:vantage/features/wishlist/presentation/cubit/favorites_cubit.dart';
import 'package:vantage/features/wishlist/presentation/cubit/favorites_state.dart';

class SearchResultsGrid extends StatelessWidget {
  const SearchResultsGrid({
    super.key,
    required this.products,
  });

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? Colors.white : VantageColors.homeCategoryLabelLight;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${products.length} Results Found',
                style: GoogleFonts.nunitoSans(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ),
            ),
          ),
          BlocBuilder<FavoritesCubit, FavoritesState>(
            buildWhen: (p, c) =>
                c is FavoritesLoaded ||
                c is FavoritesLoading ||
                c is FavoritesInitial,
            builder: (context, favState) {
              final ids =
                  favState is FavoritesLoaded ? favState.ids : <String>{};

              return SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: VantageProductCard.gridMainAxisExtent,
                ),
                itemCount: products.length,
                itemBuilder: (context, i) {
                  final product = products[i];
                  return VantageProductCard(
                    product: product,
                    onTap: () => context.router.push(
                      ProductDetailRoute(product: product),
                    ),
                    isFavorite: ids.contains(product.id),
                    onFavoriteTap: () =>
                        context.read<FavoritesCubit>().toggleFavorite(product),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
